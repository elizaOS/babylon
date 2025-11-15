/**
 * API Route: /api/users/[userId]/verify-share
 * Methods: POST (verify that a share was actually posted)
 */

import {
  authenticate,
  successResponse
} from '@/lib/api/auth-middleware'
import { prisma } from '@/lib/prisma'
import { AuthorizationError, BusinessLogicError } from '@/lib/errors'
import { withErrorHandling } from '@/lib/errors/error-handler'
import { logger } from '@/lib/logger'
import { requireUserByIdentifier } from '@/lib/users/user-lookup'
import { UserIdParamSchema, SnowflakeIdSchema } from '@/lib/validation/schemas'
import { PointsService } from '@/lib/services/points-service'
import { POINTS } from '@/lib/constants/points'
import type { NextRequest } from 'next/server'
import { z } from 'zod'

const VerifyShareRequestSchema = z.object({
  shareId: SnowflakeIdSchema,
  platform: z.enum(['twitter', 'farcaster']),
  postUrl: z.string().url().optional(), // URL to the actual post for verification
});

/**
 * POST /api/users/[userId]/verify-share
 * Verify that a share action was completed (user actually posted)
 */
export const POST = withErrorHandling(async (
  request: NextRequest,
  context: { params: Promise<{ userId: string }> }
) => {
  // Authenticate user
  const authUser = await authenticate(request);
  const { userId } = UserIdParamSchema.parse(await context.params);
  
  // Check if the authenticated user has a database record
  if (!authUser.dbUserId) {
    throw new AuthorizationError('User profile not found. Please complete onboarding first.', 'share-verification', 'create');
  }
  
  const targetUser = await requireUserByIdentifier(userId, { id: true });
  const canonicalUserId = targetUser.id;

  // Verify user is verifying their own share
  if (authUser.dbUserId !== canonicalUserId) {
    throw new AuthorizationError('You can only verify your own shares', 'share-verification', 'create');
  }

  // Parse and validate request body
  const body = await request.json();
  const { shareId, platform, postUrl } = VerifyShareRequestSchema.parse(body);

  // Get the share action
  const shareAction = await prisma.shareAction.findUnique({
    where: { id: shareId },
  });

  if (!shareAction) {
    throw new BusinessLogicError('Share action not found', 'SHARE_NOT_FOUND');
  }

  if (shareAction.userId !== canonicalUserId) {
    throw new AuthorizationError('You can only verify your own shares', 'share-verification', 'verify');
  }

  if (shareAction.verified) {
    // Calculate points based on platform (same logic as PointsService.awardShareAction)
    const pointsAmount = platform === 'twitter' ? POINTS.SHARE_TO_TWITTER : POINTS.SHARE_ACTION;
    
    return successResponse({
      message: 'Share already verified',
      verified: true,
      shareAction,
      points: {
        awarded: shareAction.pointsAwarded ? pointsAmount : 0,
        alreadyAwarded: shareAction.pointsAwarded,
      },
    });
  }

  // Require post URL for verification
  if (!postUrl) {
    throw new BusinessLogicError('Post URL is required for verification', 'MISSING_POST_URL');
  }

  // Verify the post based on platform
  let verified = false;
  let verificationDetails: Record<string, string | boolean> = {};
  let verificationError: string | null = null;

  if (platform === 'twitter') {
    // Twitter verification - STRICT MODE
    // Extract tweet ID from URL (e.g., https://twitter.com/user/status/1234567890 or https://x.com/user/status/1234567890)
    const tweetIdMatch = postUrl.match(/(?:twitter\.com|x\.com)\/[^/]+\/status\/(\d+)/);
    
    if (!tweetIdMatch || !tweetIdMatch[1]) {
      verificationError = 'Invalid Twitter/X URL format. Expected: https://twitter.com/username/status/123456789';
      logger.warn(
        `Invalid Twitter URL format: ${shareId}`,
        { shareId, postUrl, userId: canonicalUserId },
        'POST /api/users/[userId]/verify-share'
      );
    } else {
      const tweetId = tweetIdMatch[1];
      
      // Check if Twitter API is configured
      if (!process.env.TWITTER_BEARER_TOKEN) {
        verificationError = 'Twitter verification is not configured. Please contact support.';
        logger.error(
          'TWITTER_BEARER_TOKEN not configured',
          { shareId, tweetId },
          'POST /api/users/[userId]/verify-share'
        );
      } else {
        // Verify tweet exists using Twitter API v2
        try {
          const twitterResponse = await fetch(
            `https://api.twitter.com/2/tweets/${tweetId}?tweet.fields=author_id,created_at,text`,
            {
              headers: {
                'Authorization': `Bearer ${process.env.TWITTER_BEARER_TOKEN}`,
              },
            }
          );
          
          if (twitterResponse.ok) {
            const tweetData = await twitterResponse.json();
            
            if (tweetData.data) {
              verified = true;
              verificationDetails = {
                tweetId,
                tweetUrl: postUrl,
                verificationMethod: 'twitter_api_v2',
                verified: true,
                tweetText: tweetData.data.text || '',
                tweetAuthorId: tweetData.data.author_id || '',
                verifiedAt: new Date().toISOString(),
              };
              
              logger.info(
                `Twitter share verified via API: ${shareId}`,
                { shareId, tweetId, userId: canonicalUserId },
                'POST /api/users/[userId]/verify-share'
              );
            } else {
              verificationError = 'Tweet not found or has been deleted';
              logger.warn(
                `Tweet not found in API response: ${shareId}`,
                { shareId, tweetId },
                'POST /api/users/[userId]/verify-share'
              );
            }
          } else if (twitterResponse.status === 404) {
            verificationError = 'Tweet not found. Please check the URL and try again.';
            logger.warn(
              `Tweet not found (404): ${shareId}`,
              { shareId, tweetId },
              'POST /api/users/[userId]/verify-share'
            );
          } else {
            verificationError = `Twitter API error (${twitterResponse.status}). Please try again later.`;
            logger.error(
              `Twitter API error: ${shareId}`,
              { shareId, tweetId, status: twitterResponse.status },
              'POST /api/users/[userId]/verify-share'
            );
          }
        } catch (error) {
          verificationError = 'Failed to verify with Twitter API. Please try again later.';
          logger.error(
            `Twitter API verification exception: ${shareId}`,
            { shareId, tweetId, error },
            'POST /api/users/[userId]/verify-share'
          );
        }
      }
    }
  } else if (platform === 'farcaster') {
    // Farcaster verification - STRICT MODE
    // Extract cast hash from URL (e.g., https://warpcast.com/user/0x...)
    const castHashMatch = postUrl.match(/0x[a-fA-F0-9]{40,}/);
    
    if (!castHashMatch) {
      verificationError = 'Invalid Farcaster cast URL format. Expected: https://warpcast.com/username/0x...';
      logger.warn(
        `Invalid Farcaster URL format: ${shareId}`,
        { shareId, postUrl, userId: canonicalUserId },
        'POST /api/users/[userId]/verify-share'
      );
    } else {
      const castHash = castHashMatch[0];
      const hubUrl = process.env.FARCASTER_HUB_URL || 'https://hub.farcaster.xyz:2281';
      
      try {
        const hubResponse = await fetch(
          `${hubUrl}/v1/castById?hash=${castHash}`,
          {
            headers: {
              'Content-Type': 'application/json',
            },
            // Add timeout
            signal: AbortSignal.timeout(10000), // 10 second timeout
          }
        );
        
        if (hubResponse.ok) {
          const castData = await hubResponse.json();
          
          if (castData.data) {
            verified = true;
            verificationDetails = {
              castHash,
              castUrl: postUrl,
              verificationMethod: 'farcaster_hub_api',
              verified: true,
              castText: castData.data.text || '',
              castAuthorFid: castData.data.fid || '',
              verifiedAt: new Date().toISOString(),
            };
            
            logger.info(
              `Farcaster share verified via Hubs API: ${shareId}`,
              { shareId, castHash, userId: canonicalUserId },
              'POST /api/users/[userId]/verify-share'
            );
          } else {
            verificationError = 'Cast not found or has been deleted';
            logger.warn(
              `Cast not found in Hub response: ${shareId}`,
              { shareId, castHash },
              'POST /api/users/[userId]/verify-share'
            );
          }
        } else if (hubResponse.status === 404) {
          verificationError = 'Cast not found. Please check the URL and try again.';
          logger.warn(
            `Cast not found (404): ${shareId}`,
            { shareId, castHash },
            'POST /api/users/[userId]/verify-share'
          );
        } else {
          verificationError = `Farcaster Hub error (${hubResponse.status}). Please try again later.`;
          logger.error(
            `Farcaster Hub API error: ${shareId}`,
            { shareId, castHash, status: hubResponse.status },
            'POST /api/users/[userId]/verify-share'
          );
        }
      } catch (error) {
        // NO FALLBACK - strict verification only
        verificationError = 'Failed to verify with Farcaster Hub. Please try again later.';
        logger.error(
          `Farcaster Hub API verification exception: ${shareId}`,
          { shareId, castHash, error: error instanceof Error ? error.message : String(error) },
          'POST /api/users/[userId]/verify-share'
        );
      }
    }
  }

  // Award points only if verification succeeded
  let pointsAwarded = 0;
  let newPointsTotal = 0;

  if (verified) {
    // Award points through PointsService
    const pointsResult = await PointsService.awardShareAction(
      canonicalUserId,
      platform,
      shareAction.contentType,
      shareAction.contentId || undefined
    );

    if (pointsResult.success) {
      pointsAwarded = pointsResult.pointsAwarded;
      newPointsTotal = pointsResult.newTotal;
      
      logger.info(
        `Awarded ${pointsAwarded} points for verified share`,
        { shareId, userId: canonicalUserId, platform, pointsAwarded },
        'POST /api/users/[userId]/verify-share'
      );
    }
  }

  // Update share action with verification status and points
  const updatedShareAction = await prisma.shareAction.update({
    where: { id: shareId },
    data: {
      verified,
      verifiedAt: verified ? new Date() : null,
      verificationDetails: verified ? JSON.stringify(verificationDetails) : null,
      pointsAwarded: verified && pointsAwarded > 0,
    },
  });

  return successResponse({
    verified,
    shareAction: updatedShareAction,
    points: {
      awarded: pointsAwarded,
      newTotal: newPointsTotal,
    },
    message: verified 
      ? `Share verified successfully! You earned ${pointsAwarded} points.` 
      : verificationError || 'Could not verify share. Please provide a valid post URL.',
  });
});

