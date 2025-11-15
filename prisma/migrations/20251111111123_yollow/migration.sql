-- CreateEnum
CREATE TYPE "OnboardingStatus" AS ENUM ('PENDING_PROFILE', 'PENDING_ONCHAIN', 'ONCHAIN_IN_PROGRESS', 'ONCHAIN_FAILED', 'COMPLETED');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "privyId" TEXT,
    "walletAddress" TEXT,
    "username" TEXT,
    "displayName" TEXT,
    "bio" TEXT,
    "profileImageUrl" TEXT,
    "coverImageUrl" TEXT,
    "isActor" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "personality" TEXT,
    "postStyle" TEXT,
    "postExample" TEXT,
    "virtualBalance" DECIMAL(18,2) NOT NULL DEFAULT 1000,
    "totalDeposited" DECIMAL(18,2) NOT NULL DEFAULT 1000,
    "totalWithdrawn" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "lifetimePnL" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "onChainRegistered" BOOLEAN NOT NULL DEFAULT false,
    "nftTokenId" INTEGER,
    "registrationTxHash" TEXT,
    "registrationBlockNumber" BIGINT,
    "registrationGasUsed" BIGINT,
    "registrationTimestamp" TIMESTAMP(3),
    "agent0TokenId" INTEGER,
    "agent0MetadataCID" TEXT,
    "agent0RegisteredAt" TIMESTAMP(3),
    "reputationPoints" INTEGER NOT NULL DEFAULT 1000,
    "invitePoints" INTEGER NOT NULL DEFAULT 0,
    "earnedPoints" INTEGER NOT NULL DEFAULT 0,
    "bonusPoints" INTEGER NOT NULL DEFAULT 0,
    "profileComplete" BOOLEAN NOT NULL DEFAULT false,
    "hasProfileImage" BOOLEAN NOT NULL DEFAULT false,
    "hasUsername" BOOLEAN NOT NULL DEFAULT false,
    "hasBio" BOOLEAN NOT NULL DEFAULT false,
    "profileSetupCompletedAt" TIMESTAMP(3),
    "usernameChangedAt" TIMESTAMP(3),
    "pointsAwardedForProfile" BOOLEAN NOT NULL DEFAULT false,
    "pointsAwardedForProfileImage" BOOLEAN NOT NULL DEFAULT false,
    "pointsAwardedForUsername" BOOLEAN NOT NULL DEFAULT false,
    "hasFarcaster" BOOLEAN NOT NULL DEFAULT false,
    "hasTwitter" BOOLEAN NOT NULL DEFAULT false,
    "farcasterUsername" TEXT,
    "twitterUsername" TEXT,
    "pointsAwardedForFarcaster" BOOLEAN NOT NULL DEFAULT false,
    "pointsAwardedForTwitter" BOOLEAN NOT NULL DEFAULT false,
    "pointsAwardedForWallet" BOOLEAN NOT NULL DEFAULT false,
    "twitterId" TEXT,
    "twitterAccessToken" TEXT,
    "twitterRefreshToken" TEXT,
    "twitterTokenExpiresAt" TIMESTAMP(3),
    "twitterVerifiedAt" TIMESTAMP(3),
    "farcasterFid" TEXT,
    "farcasterDisplayName" TEXT,
    "farcasterPfpUrl" TEXT,
    "farcasterVerifiedAt" TIMESTAMP(3),
    "showTwitterPublic" BOOLEAN NOT NULL DEFAULT true,
    "showFarcasterPublic" BOOLEAN NOT NULL DEFAULT true,
    "showWalletPublic" BOOLEAN NOT NULL DEFAULT true,
    "referralCode" TEXT,
    "referredBy" TEXT,
    "referralCount" INTEGER NOT NULL DEFAULT 0,
    "bannerLastShown" TIMESTAMP(3),
    "bannerDismissCount" INTEGER NOT NULL DEFAULT 0,
    "waitlistPosition" INTEGER,
    "waitlistJoinedAt" TIMESTAMP(3),
    "isWaitlistActive" BOOLEAN NOT NULL DEFAULT false,
    "waitlistGraduatedAt" TIMESTAMP(3),
    "pointsAwardedForEmail" BOOLEAN NOT NULL DEFAULT false,
    "emailVerified" BOOLEAN NOT NULL DEFAULT false,
    "email" TEXT,
    "tosAccepted" BOOLEAN NOT NULL DEFAULT false,
    "tosAcceptedAt" TIMESTAMP(3),
    "tosAcceptedVersion" TEXT DEFAULT '2025-11-11',
    "privacyPolicyAccepted" BOOLEAN NOT NULL DEFAULT false,
    "privacyPolicyAcceptedAt" TIMESTAMP(3),
    "privacyPolicyAcceptedVersion" TEXT DEFAULT '2025-11-11',
    "totalFeesEarned" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "totalFeesPaid" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "agent0FeedbackCount" INTEGER,
    "agent0TrustScore" DOUBLE PRECISION,
    "role" TEXT,
    "isAdmin" BOOLEAN NOT NULL DEFAULT false,
    "isBanned" BOOLEAN NOT NULL DEFAULT false,
    "bannedAt" TIMESTAMP(3),
    "bannedReason" TEXT,
    "bannedBy" TEXT,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OnboardingIntent" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "status" "OnboardingStatus" NOT NULL DEFAULT 'PENDING_PROFILE',
    "referralCode" TEXT,
    "payload" JSONB,
    "profileApplied" BOOLEAN NOT NULL DEFAULT false,
    "profileCompletedAt" TIMESTAMP(3),
    "onchainStartedAt" TIMESTAMP(3),
    "onchainCompletedAt" TIMESTAMP(3),
    "lastError" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "OnboardingIntent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Post" (
    "id" TEXT NOT NULL,
    "type" TEXT NOT NULL DEFAULT 'post',
    "content" TEXT NOT NULL,
    "fullContent" TEXT,
    "articleTitle" TEXT,
    "byline" TEXT,
    "biasScore" DOUBLE PRECISION,
    "sentiment" TEXT,
    "slant" TEXT,
    "category" TEXT,
    "authorId" TEXT NOT NULL,
    "gameId" TEXT,
    "dayNumber" INTEGER,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Post_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Comment" (
    "id" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "postId" TEXT NOT NULL,
    "authorId" TEXT NOT NULL,
    "parentCommentId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Comment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Reaction" (
    "id" TEXT NOT NULL,
    "postId" TEXT,
    "commentId" TEXT,
    "userId" TEXT NOT NULL,
    "type" TEXT NOT NULL DEFAULT 'like',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Reaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Follow" (
    "id" TEXT NOT NULL,
    "followerId" TEXT NOT NULL,
    "followingId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Follow_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Favorite" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "targetUserId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Favorite_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Share" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "postId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Share_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Market" (
    "id" TEXT NOT NULL,
    "question" TEXT NOT NULL,
    "description" TEXT,
    "gameId" TEXT,
    "dayNumber" INTEGER,
    "yesShares" DECIMAL(18,6) NOT NULL DEFAULT 0,
    "noShares" DECIMAL(18,6) NOT NULL DEFAULT 0,
    "liquidity" DECIMAL(18,6) NOT NULL,
    "resolved" BOOLEAN NOT NULL DEFAULT false,
    "resolution" BOOLEAN,
    "endDate" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Market_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Position" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "marketId" TEXT NOT NULL,
    "questionId" INTEGER,
    "side" BOOLEAN NOT NULL,
    "shares" DECIMAL(18,6) NOT NULL,
    "avgPrice" DECIMAL(18,6) NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "status" TEXT NOT NULL DEFAULT 'active',
    "outcome" BOOLEAN,
    "pnl" DECIMAL(18,2),
    "resolvedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Position_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Chat" (
    "id" TEXT NOT NULL,
    "name" TEXT,
    "isGroup" BOOLEAN NOT NULL DEFAULT false,
    "gameId" TEXT,
    "dayNumber" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Chat_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ChatParticipant" (
    "id" TEXT NOT NULL,
    "chatId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "joinedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ChatParticipant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Message" (
    "id" TEXT NOT NULL,
    "chatId" TEXT NOT NULL,
    "senderId" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Message_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Game" (
    "id" TEXT NOT NULL,
    "currentDay" INTEGER NOT NULL DEFAULT 1,
    "currentDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "isRunning" BOOLEAN NOT NULL DEFAULT false,
    "isContinuous" BOOLEAN NOT NULL DEFAULT true,
    "speed" INTEGER NOT NULL DEFAULT 60000,
    "startedAt" TIMESTAMP(3),
    "pausedAt" TIMESTAMP(3),
    "completedAt" TIMESTAMP(3),
    "lastTickAt" TIMESTAMP(3),
    "lastSnapshotAt" TIMESTAMP(3),
    "activeQuestions" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Game_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserInteraction" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "npcId" TEXT NOT NULL,
    "postId" TEXT NOT NULL,
    "commentId" TEXT NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "qualityScore" DOUBLE PRECISION NOT NULL DEFAULT 1.0,
    "wasFollowed" BOOLEAN NOT NULL DEFAULT false,
    "wasInvitedToChat" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "UserInteraction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "GroupChatMembership" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "chatId" TEXT NOT NULL,
    "npcAdminId" TEXT NOT NULL,
    "joinedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastMessageAt" TIMESTAMP(3),
    "messageCount" INTEGER NOT NULL DEFAULT 0,
    "qualityScore" DOUBLE PRECISION NOT NULL DEFAULT 1.0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "sweepReason" TEXT,
    "removedAt" TIMESTAMP(3),

    CONSTRAINT "GroupChatMembership_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FollowStatus" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "npcId" TEXT NOT NULL,
    "followedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "unfollowedAt" TIMESTAMP(3),
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "followReason" TEXT,

    CONSTRAINT "FollowStatus_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PerpPosition" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "ticker" TEXT NOT NULL,
    "organizationId" TEXT NOT NULL,
    "side" TEXT NOT NULL,
    "entryPrice" DOUBLE PRECISION NOT NULL,
    "currentPrice" DOUBLE PRECISION NOT NULL,
    "size" DOUBLE PRECISION NOT NULL,
    "leverage" INTEGER NOT NULL,
    "liquidationPrice" DOUBLE PRECISION NOT NULL,
    "unrealizedPnL" DOUBLE PRECISION NOT NULL,
    "unrealizedPnLPercent" DOUBLE PRECISION NOT NULL,
    "fundingPaid" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "openedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastUpdated" TIMESTAMP(3) NOT NULL,
    "closedAt" TIMESTAMP(3),
    "realizedPnL" DOUBLE PRECISION,

    CONSTRAINT "PerpPosition_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BalanceTransaction" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL,
    "balanceBefore" DECIMAL(18,2) NOT NULL,
    "balanceAfter" DECIMAL(18,2) NOT NULL,
    "relatedId" TEXT,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "BalanceTransaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Question" (
    "id" TEXT NOT NULL,
    "questionNumber" INTEGER NOT NULL,
    "text" TEXT NOT NULL,
    "scenarioId" INTEGER NOT NULL,
    "outcome" BOOLEAN NOT NULL,
    "rank" INTEGER NOT NULL,
    "createdDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "resolutionDate" TIMESTAMP(3) NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'active',
    "resolvedOutcome" BOOLEAN,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Question_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Organization" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "canBeInvolved" BOOLEAN NOT NULL DEFAULT true,
    "initialPrice" DOUBLE PRECISION,
    "currentPrice" DOUBLE PRECISION,
    "imageUrl" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Organization_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StockPrice" (
    "id" TEXT NOT NULL,
    "organizationId" TEXT NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "change" DOUBLE PRECISION NOT NULL,
    "changePercent" DOUBLE PRECISION NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "isSnapshot" BOOLEAN NOT NULL DEFAULT false,
    "openPrice" DOUBLE PRECISION,
    "highPrice" DOUBLE PRECISION,
    "lowPrice" DOUBLE PRECISION,
    "volume" DOUBLE PRECISION,

    CONSTRAINT "StockPrice_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WorldEvent" (
    "id" TEXT NOT NULL,
    "eventType" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "actors" TEXT[],
    "relatedQuestion" INTEGER,
    "pointsToward" TEXT,
    "visibility" TEXT NOT NULL DEFAULT 'public',
    "gameId" TEXT,
    "dayNumber" INTEGER,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "WorldEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Actor" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "domain" TEXT[],
    "personality" TEXT,
    "tier" TEXT,
    "affiliations" TEXT[],
    "postStyle" TEXT,
    "postExample" TEXT[],
    "role" TEXT,
    "initialLuck" TEXT NOT NULL DEFAULT 'medium',
    "initialMood" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "hasPool" BOOLEAN NOT NULL DEFAULT false,
    "tradingBalance" DECIMAL(18,2) NOT NULL DEFAULT 10000,
    "reputationPoints" INTEGER NOT NULL DEFAULT 10000,
    "profileImageUrl" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Actor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ActorFollow" (
    "id" TEXT NOT NULL,
    "followerId" TEXT NOT NULL,
    "followingId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "isMutual" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "ActorFollow_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserActorFollow" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "actorId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserActorFollow_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ActorRelationship" (
    "id" TEXT NOT NULL,
    "actor1Id" TEXT NOT NULL,
    "actor2Id" TEXT NOT NULL,
    "relationshipType" TEXT NOT NULL,
    "strength" DOUBLE PRECISION NOT NULL,
    "sentiment" DOUBLE PRECISION NOT NULL,
    "isPublic" BOOLEAN NOT NULL DEFAULT true,
    "history" TEXT,
    "affects" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ActorRelationship_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Notification" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "actorId" TEXT,
    "postId" TEXT,
    "commentId" TEXT,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "read" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Pool" (
    "id" TEXT NOT NULL,
    "npcActorId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "totalValue" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "totalDeposits" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "availableBalance" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "lifetimePnL" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "performanceFeeRate" DOUBLE PRECISION NOT NULL DEFAULT 0.05,
    "totalFeesCollected" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "openedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "closedAt" TIMESTAMP(3),
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'ACTIVE',
    "currentPrice" DOUBLE PRECISION,
    "priceChange24h" DOUBLE PRECISION,
    "volume24h" DECIMAL(18,2),
    "tvl" DECIMAL(18,2),

    CONSTRAINT "Pool_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PoolDeposit" (
    "id" TEXT NOT NULL,
    "poolId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL,
    "shares" DECIMAL(18,6) NOT NULL,
    "currentValue" DECIMAL(18,2) NOT NULL,
    "unrealizedPnL" DECIMAL(18,2) NOT NULL,
    "depositedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "withdrawnAt" TIMESTAMP(3),
    "withdrawnAmount" DECIMAL(18,2),

    CONSTRAINT "PoolDeposit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PoolPosition" (
    "id" TEXT NOT NULL,
    "poolId" TEXT NOT NULL,
    "marketType" TEXT NOT NULL,
    "ticker" TEXT,
    "marketId" TEXT,
    "side" TEXT NOT NULL,
    "entryPrice" DOUBLE PRECISION NOT NULL,
    "currentPrice" DOUBLE PRECISION NOT NULL,
    "size" DOUBLE PRECISION NOT NULL,
    "shares" DOUBLE PRECISION,
    "leverage" INTEGER,
    "liquidationPrice" DOUBLE PRECISION,
    "unrealizedPnL" DOUBLE PRECISION NOT NULL,
    "openedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "closedAt" TIMESTAMP(3),
    "realizedPnL" DOUBLE PRECISION,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PoolPosition_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NPCTrade" (
    "id" TEXT NOT NULL,
    "npcActorId" TEXT NOT NULL,
    "poolId" TEXT,
    "marketType" TEXT NOT NULL,
    "ticker" TEXT,
    "marketId" TEXT,
    "action" TEXT NOT NULL,
    "side" TEXT,
    "amount" DOUBLE PRECISION NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "sentiment" DOUBLE PRECISION,
    "reason" TEXT,
    "postId" TEXT,
    "executedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "NPCTrade_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PointsTransaction" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "amount" INTEGER NOT NULL,
    "pointsBefore" INTEGER NOT NULL,
    "pointsAfter" INTEGER NOT NULL,
    "reason" TEXT NOT NULL,
    "metadata" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "paymentRequestId" TEXT,
    "paymentTxHash" TEXT,
    "paymentAmount" TEXT,
    "paymentVerified" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "PointsTransaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Referral" (
    "id" TEXT NOT NULL,
    "referrerId" TEXT NOT NULL,
    "referredUserId" TEXT,
    "referralCode" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completedAt" TIMESTAMP(3),

    CONSTRAINT "Referral_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ShareAction" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "platform" TEXT NOT NULL,
    "contentType" TEXT NOT NULL,
    "contentId" TEXT,
    "url" TEXT,
    "pointsAwarded" BOOLEAN NOT NULL DEFAULT false,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "verifiedAt" TIMESTAMP(3),
    "verificationDetails" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ShareAction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TradingFee" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "tradeType" TEXT NOT NULL,
    "tradeId" TEXT,
    "marketId" TEXT,
    "feeAmount" DECIMAL(18,2) NOT NULL,
    "platformFee" DECIMAL(18,2) NOT NULL,
    "referrerFee" DECIMAL(18,2) NOT NULL,
    "referrerId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "TradingFee_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tag" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "displayName" TEXT NOT NULL,
    "category" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PostTag" (
    "id" TEXT NOT NULL,
    "postId" TEXT NOT NULL,
    "tagId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PostTag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TrendingTag" (
    "id" TEXT NOT NULL,
    "tagId" TEXT NOT NULL,
    "score" DOUBLE PRECISION NOT NULL,
    "postCount" INTEGER NOT NULL,
    "rank" INTEGER NOT NULL,
    "calculatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "windowStart" TIMESTAMP(3) NOT NULL,
    "windowEnd" TIMESTAMP(3) NOT NULL,
    "relatedContext" TEXT,

    CONSTRAINT "TrendingTag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WidgetCache" (
    "widget" TEXT NOT NULL,
    "data" JSONB NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "WidgetCache_pkey" PRIMARY KEY ("widget")
);

-- CreateTable
CREATE TABLE "GameConfig" (
    "id" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "value" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "GameConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Feedback" (
    "id" TEXT NOT NULL,
    "fromUserId" TEXT,
    "fromAgentId" TEXT,
    "toUserId" TEXT,
    "toAgentId" TEXT,
    "score" INTEGER NOT NULL,
    "rating" INTEGER,
    "comment" TEXT,
    "category" TEXT,
    "gameId" TEXT,
    "tradeId" TEXT,
    "positionId" TEXT,
    "interactionType" TEXT NOT NULL,
    "onChainTxHash" TEXT,
    "agent0TokenId" INTEGER,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Feedback_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AgentPerformanceMetrics" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "gamesPlayed" INTEGER NOT NULL DEFAULT 0,
    "gamesWon" INTEGER NOT NULL DEFAULT 0,
    "averageGameScore" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "lastGameScore" DOUBLE PRECISION,
    "lastGamePlayedAt" TIMESTAMP(3),
    "normalizedPnL" DOUBLE PRECISION NOT NULL DEFAULT 0.5,
    "totalTrades" INTEGER NOT NULL DEFAULT 0,
    "profitableTrades" INTEGER NOT NULL DEFAULT 0,
    "winRate" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "averageROI" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "sharpeRatio" DOUBLE PRECISION,
    "totalFeedbackCount" INTEGER NOT NULL DEFAULT 0,
    "averageFeedbackScore" DOUBLE PRECISION NOT NULL DEFAULT 50,
    "averageRating" DOUBLE PRECISION,
    "positiveCount" INTEGER NOT NULL DEFAULT 0,
    "neutralCount" INTEGER NOT NULL DEFAULT 0,
    "negativeCount" INTEGER NOT NULL DEFAULT 0,
    "reputationScore" DOUBLE PRECISION NOT NULL DEFAULT 50,
    "trustLevel" TEXT NOT NULL DEFAULT 'UNRATED',
    "confidenceScore" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "onChainReputationSync" BOOLEAN NOT NULL DEFAULT false,
    "lastSyncedAt" TIMESTAMP(3),
    "onChainTrustScore" DOUBLE PRECISION,
    "onChainAccuracyScore" DOUBLE PRECISION,
    "firstActivityAt" TIMESTAMP(3),
    "lastActivityAt" TIMESTAMP(3),
    "totalInteractions" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AgentPerformanceMetrics_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_privyId_key" ON "User"("privyId");

-- CreateIndex
CREATE UNIQUE INDEX "User_walletAddress_key" ON "User"("walletAddress");

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");

-- CreateIndex
CREATE UNIQUE INDEX "User_nftTokenId_key" ON "User"("nftTokenId");

-- CreateIndex
CREATE UNIQUE INDEX "User_twitterId_key" ON "User"("twitterId");

-- CreateIndex
CREATE UNIQUE INDEX "User_farcasterFid_key" ON "User"("farcasterFid");

-- CreateIndex
CREATE UNIQUE INDEX "User_referralCode_key" ON "User"("referralCode");

-- CreateIndex
CREATE INDEX "User_walletAddress_idx" ON "User"("walletAddress");

-- CreateIndex
CREATE INDEX "User_username_idx" ON "User"("username");

-- CreateIndex
CREATE INDEX "User_isActor_idx" ON "User"("isActor");

-- CreateIndex
CREATE INDEX "User_reputationPoints_idx" ON "User"("reputationPoints" DESC);

-- CreateIndex
CREATE INDEX "User_referralCode_idx" ON "User"("referralCode");

-- CreateIndex
CREATE INDEX "User_waitlistPosition_idx" ON "User"("waitlistPosition");

-- CreateIndex
CREATE INDEX "User_waitlistJoinedAt_idx" ON "User"("waitlistJoinedAt");

-- CreateIndex
CREATE INDEX "User_invitePoints_idx" ON "User"("invitePoints" DESC);

-- CreateIndex
CREATE INDEX "User_earnedPoints_idx" ON "User"("earnedPoints" DESC);

-- CreateIndex
CREATE INDEX "OnboardingIntent_status_idx" ON "OnboardingIntent"("status");

-- CreateIndex
CREATE INDEX "OnboardingIntent_createdAt_idx" ON "OnboardingIntent"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "OnboardingIntent_userId_key" ON "OnboardingIntent"("userId");

-- CreateIndex
CREATE INDEX "Post_authorId_timestamp_idx" ON "Post"("authorId", "timestamp" DESC);

-- CreateIndex
CREATE INDEX "Post_timestamp_idx" ON "Post"("timestamp" DESC);

-- CreateIndex
CREATE INDEX "Post_type_timestamp_idx" ON "Post"("type", "timestamp" DESC);

-- CreateIndex
CREATE INDEX "Post_gameId_dayNumber_idx" ON "Post"("gameId", "dayNumber");

-- CreateIndex
CREATE INDEX "Comment_postId_createdAt_idx" ON "Comment"("postId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "Comment_authorId_idx" ON "Comment"("authorId");

-- CreateIndex
CREATE INDEX "Comment_parentCommentId_idx" ON "Comment"("parentCommentId");

-- CreateIndex
CREATE INDEX "Reaction_postId_idx" ON "Reaction"("postId");

-- CreateIndex
CREATE INDEX "Reaction_commentId_idx" ON "Reaction"("commentId");

-- CreateIndex
CREATE INDEX "Reaction_userId_idx" ON "Reaction"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Reaction_postId_userId_type_key" ON "Reaction"("postId", "userId", "type");

-- CreateIndex
CREATE UNIQUE INDEX "Reaction_commentId_userId_type_key" ON "Reaction"("commentId", "userId", "type");

-- CreateIndex
CREATE INDEX "Follow_followerId_idx" ON "Follow"("followerId");

-- CreateIndex
CREATE INDEX "Follow_followingId_idx" ON "Follow"("followingId");

-- CreateIndex
CREATE UNIQUE INDEX "Follow_followerId_followingId_key" ON "Follow"("followerId", "followingId");

-- CreateIndex
CREATE INDEX "Favorite_userId_idx" ON "Favorite"("userId");

-- CreateIndex
CREATE INDEX "Favorite_targetUserId_idx" ON "Favorite"("targetUserId");

-- CreateIndex
CREATE UNIQUE INDEX "Favorite_userId_targetUserId_key" ON "Favorite"("userId", "targetUserId");

-- CreateIndex
CREATE INDEX "Share_userId_idx" ON "Share"("userId");

-- CreateIndex
CREATE INDEX "Share_postId_idx" ON "Share"("postId");

-- CreateIndex
CREATE INDEX "Share_createdAt_idx" ON "Share"("createdAt" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "Share_userId_postId_key" ON "Share"("userId", "postId");

-- CreateIndex
CREATE INDEX "Market_gameId_dayNumber_idx" ON "Market"("gameId", "dayNumber");

-- CreateIndex
CREATE INDEX "Market_resolved_endDate_idx" ON "Market"("resolved", "endDate");

-- CreateIndex
CREATE INDEX "Market_createdAt_idx" ON "Market"("createdAt" DESC);

-- CreateIndex
CREATE INDEX "Position_userId_idx" ON "Position"("userId");

-- CreateIndex
CREATE INDEX "Position_marketId_idx" ON "Position"("marketId");

-- CreateIndex
CREATE INDEX "Position_userId_marketId_idx" ON "Position"("userId", "marketId");

-- CreateIndex
CREATE INDEX "Position_questionId_idx" ON "Position"("questionId");

-- CreateIndex
CREATE INDEX "Position_status_idx" ON "Position"("status");

-- CreateIndex
CREATE INDEX "Position_userId_status_idx" ON "Position"("userId", "status");

-- CreateIndex
CREATE INDEX "Chat_gameId_dayNumber_idx" ON "Chat"("gameId", "dayNumber");

-- CreateIndex
CREATE INDEX "Chat_isGroup_idx" ON "Chat"("isGroup");

-- CreateIndex
CREATE INDEX "ChatParticipant_chatId_idx" ON "ChatParticipant"("chatId");

-- CreateIndex
CREATE INDEX "ChatParticipant_userId_idx" ON "ChatParticipant"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "ChatParticipant_chatId_userId_key" ON "ChatParticipant"("chatId", "userId");

-- CreateIndex
CREATE INDEX "Message_chatId_createdAt_idx" ON "Message"("chatId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "Message_senderId_idx" ON "Message"("senderId");

-- CreateIndex
CREATE INDEX "Game_isRunning_idx" ON "Game"("isRunning");

-- CreateIndex
CREATE INDEX "Game_isContinuous_idx" ON "Game"("isContinuous");

-- CreateIndex
CREATE INDEX "UserInteraction_userId_npcId_timestamp_idx" ON "UserInteraction"("userId", "npcId", "timestamp" DESC);

-- CreateIndex
CREATE INDEX "UserInteraction_userId_timestamp_idx" ON "UserInteraction"("userId", "timestamp" DESC);

-- CreateIndex
CREATE INDEX "UserInteraction_npcId_timestamp_idx" ON "UserInteraction"("npcId", "timestamp" DESC);

-- CreateIndex
CREATE INDEX "GroupChatMembership_userId_isActive_idx" ON "GroupChatMembership"("userId", "isActive");

-- CreateIndex
CREATE INDEX "GroupChatMembership_chatId_isActive_idx" ON "GroupChatMembership"("chatId", "isActive");

-- CreateIndex
CREATE INDEX "GroupChatMembership_lastMessageAt_idx" ON "GroupChatMembership"("lastMessageAt");

-- CreateIndex
CREATE UNIQUE INDEX "GroupChatMembership_userId_chatId_key" ON "GroupChatMembership"("userId", "chatId");

-- CreateIndex
CREATE INDEX "FollowStatus_userId_isActive_idx" ON "FollowStatus"("userId", "isActive");

-- CreateIndex
CREATE INDEX "FollowStatus_npcId_idx" ON "FollowStatus"("npcId");

-- CreateIndex
CREATE UNIQUE INDEX "FollowStatus_userId_npcId_key" ON "FollowStatus"("userId", "npcId");

-- CreateIndex
CREATE INDEX "PerpPosition_userId_closedAt_idx" ON "PerpPosition"("userId", "closedAt");

-- CreateIndex
CREATE INDEX "PerpPosition_ticker_idx" ON "PerpPosition"("ticker");

-- CreateIndex
CREATE INDEX "PerpPosition_organizationId_idx" ON "PerpPosition"("organizationId");

-- CreateIndex
CREATE INDEX "BalanceTransaction_userId_createdAt_idx" ON "BalanceTransaction"("userId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "BalanceTransaction_type_idx" ON "BalanceTransaction"("type");

-- CreateIndex
CREATE UNIQUE INDEX "Question_questionNumber_key" ON "Question"("questionNumber");

-- CreateIndex
CREATE INDEX "Question_status_resolutionDate_idx" ON "Question"("status", "resolutionDate");

-- CreateIndex
CREATE INDEX "Question_createdDate_idx" ON "Question"("createdDate" DESC);

-- CreateIndex
CREATE INDEX "Organization_type_idx" ON "Organization"("type");

-- CreateIndex
CREATE INDEX "Organization_currentPrice_idx" ON "Organization"("currentPrice");

-- CreateIndex
CREATE INDEX "StockPrice_organizationId_timestamp_idx" ON "StockPrice"("organizationId", "timestamp" DESC);

-- CreateIndex
CREATE INDEX "StockPrice_timestamp_idx" ON "StockPrice"("timestamp" DESC);

-- CreateIndex
CREATE INDEX "StockPrice_isSnapshot_timestamp_idx" ON "StockPrice"("isSnapshot", "timestamp");

-- CreateIndex
CREATE INDEX "WorldEvent_gameId_dayNumber_idx" ON "WorldEvent"("gameId", "dayNumber");

-- CreateIndex
CREATE INDEX "WorldEvent_timestamp_idx" ON "WorldEvent"("timestamp" DESC);

-- CreateIndex
CREATE INDEX "WorldEvent_relatedQuestion_idx" ON "WorldEvent"("relatedQuestion");

-- CreateIndex
CREATE INDEX "Actor_tier_idx" ON "Actor"("tier");

-- CreateIndex
CREATE INDEX "Actor_role_idx" ON "Actor"("role");

-- CreateIndex
CREATE INDEX "Actor_hasPool_idx" ON "Actor"("hasPool");

-- CreateIndex
CREATE INDEX "Actor_reputationPoints_idx" ON "Actor"("reputationPoints" DESC);

-- CreateIndex
CREATE INDEX "ActorFollow_followerId_idx" ON "ActorFollow"("followerId");

-- CreateIndex
CREATE INDEX "ActorFollow_followingId_idx" ON "ActorFollow"("followingId");

-- CreateIndex
CREATE INDEX "ActorFollow_isMutual_idx" ON "ActorFollow"("isMutual");

-- CreateIndex
CREATE UNIQUE INDEX "ActorFollow_followerId_followingId_key" ON "ActorFollow"("followerId", "followingId");

-- CreateIndex
CREATE INDEX "UserActorFollow_userId_idx" ON "UserActorFollow"("userId");

-- CreateIndex
CREATE INDEX "UserActorFollow_actorId_idx" ON "UserActorFollow"("actorId");

-- CreateIndex
CREATE UNIQUE INDEX "UserActorFollow_userId_actorId_key" ON "UserActorFollow"("userId", "actorId");

-- CreateIndex
CREATE INDEX "ActorRelationship_actor1Id_idx" ON "ActorRelationship"("actor1Id");

-- CreateIndex
CREATE INDEX "ActorRelationship_actor2Id_idx" ON "ActorRelationship"("actor2Id");

-- CreateIndex
CREATE INDEX "ActorRelationship_relationshipType_idx" ON "ActorRelationship"("relationshipType");

-- CreateIndex
CREATE INDEX "ActorRelationship_strength_idx" ON "ActorRelationship"("strength");

-- CreateIndex
CREATE INDEX "ActorRelationship_sentiment_idx" ON "ActorRelationship"("sentiment");

-- CreateIndex
CREATE UNIQUE INDEX "ActorRelationship_actor1Id_actor2Id_key" ON "ActorRelationship"("actor1Id", "actor2Id");

-- CreateIndex
CREATE INDEX "Notification_userId_read_createdAt_idx" ON "Notification"("userId", "read", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "Notification_userId_createdAt_idx" ON "Notification"("userId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "Notification_read_idx" ON "Notification"("read");

-- CreateIndex
CREATE INDEX "Pool_npcActorId_idx" ON "Pool"("npcActorId");

-- CreateIndex
CREATE INDEX "Pool_isActive_idx" ON "Pool"("isActive");

-- CreateIndex
CREATE INDEX "Pool_totalValue_idx" ON "Pool"("totalValue");

-- CreateIndex
CREATE INDEX "Pool_status_idx" ON "Pool"("status");

-- CreateIndex
CREATE INDEX "Pool_volume24h_idx" ON "Pool"("volume24h");

-- CreateIndex
CREATE INDEX "PoolDeposit_poolId_userId_idx" ON "PoolDeposit"("poolId", "userId");

-- CreateIndex
CREATE INDEX "PoolDeposit_userId_depositedAt_idx" ON "PoolDeposit"("userId", "depositedAt" DESC);

-- CreateIndex
CREATE INDEX "PoolDeposit_poolId_withdrawnAt_idx" ON "PoolDeposit"("poolId", "withdrawnAt");

-- CreateIndex
CREATE INDEX "PoolPosition_poolId_closedAt_idx" ON "PoolPosition"("poolId", "closedAt");

-- CreateIndex
CREATE INDEX "PoolPosition_marketType_ticker_idx" ON "PoolPosition"("marketType", "ticker");

-- CreateIndex
CREATE INDEX "PoolPosition_marketType_marketId_idx" ON "PoolPosition"("marketType", "marketId");

-- CreateIndex
CREATE INDEX "NPCTrade_npcActorId_executedAt_idx" ON "NPCTrade"("npcActorId", "executedAt" DESC);

-- CreateIndex
CREATE INDEX "NPCTrade_poolId_executedAt_idx" ON "NPCTrade"("poolId", "executedAt" DESC);

-- CreateIndex
CREATE INDEX "NPCTrade_marketType_ticker_idx" ON "NPCTrade"("marketType", "ticker");

-- CreateIndex
CREATE INDEX "NPCTrade_executedAt_idx" ON "NPCTrade"("executedAt" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "PointsTransaction_paymentRequestId_key" ON "PointsTransaction"("paymentRequestId");

-- CreateIndex
CREATE INDEX "PointsTransaction_userId_createdAt_idx" ON "PointsTransaction"("userId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "PointsTransaction_reason_idx" ON "PointsTransaction"("reason");

-- CreateIndex
CREATE INDEX "PointsTransaction_createdAt_idx" ON "PointsTransaction"("createdAt" DESC);

-- CreateIndex
CREATE INDEX "PointsTransaction_paymentRequestId_idx" ON "PointsTransaction"("paymentRequestId");

-- CreateIndex
CREATE UNIQUE INDEX "Referral_referralCode_key" ON "Referral"("referralCode");

-- CreateIndex
CREATE INDEX "Referral_referrerId_idx" ON "Referral"("referrerId");

-- CreateIndex
CREATE INDEX "Referral_referredUserId_idx" ON "Referral"("referredUserId");

-- CreateIndex
CREATE INDEX "Referral_referralCode_idx" ON "Referral"("referralCode");

-- CreateIndex
CREATE INDEX "Referral_status_createdAt_idx" ON "Referral"("status", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "ShareAction_userId_createdAt_idx" ON "ShareAction"("userId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "ShareAction_platform_idx" ON "ShareAction"("platform");

-- CreateIndex
CREATE INDEX "ShareAction_contentType_idx" ON "ShareAction"("contentType");

-- CreateIndex
CREATE INDEX "ShareAction_verified_idx" ON "ShareAction"("verified");

-- CreateIndex
CREATE INDEX "TradingFee_userId_createdAt_idx" ON "TradingFee"("userId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "TradingFee_referrerId_createdAt_idx" ON "TradingFee"("referrerId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "TradingFee_tradeType_idx" ON "TradingFee"("tradeType");

-- CreateIndex
CREATE INDEX "TradingFee_createdAt_idx" ON "TradingFee"("createdAt" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "Tag_name_key" ON "Tag"("name");

-- CreateIndex
CREATE INDEX "Tag_name_idx" ON "Tag"("name");

-- CreateIndex
CREATE INDEX "PostTag_postId_idx" ON "PostTag"("postId");

-- CreateIndex
CREATE INDEX "PostTag_tagId_idx" ON "PostTag"("tagId");

-- CreateIndex
CREATE INDEX "PostTag_tagId_createdAt_idx" ON "PostTag"("tagId", "createdAt" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "PostTag_postId_tagId_key" ON "PostTag"("postId", "tagId");

-- CreateIndex
CREATE INDEX "TrendingTag_rank_calculatedAt_idx" ON "TrendingTag"("rank", "calculatedAt" DESC);

-- CreateIndex
CREATE INDEX "TrendingTag_tagId_calculatedAt_idx" ON "TrendingTag"("tagId", "calculatedAt" DESC);

-- CreateIndex
CREATE INDEX "TrendingTag_calculatedAt_idx" ON "TrendingTag"("calculatedAt" DESC);

-- CreateIndex
CREATE INDEX "WidgetCache_widget_updatedAt_idx" ON "WidgetCache"("widget", "updatedAt" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "GameConfig_key_key" ON "GameConfig"("key");

-- CreateIndex
CREATE INDEX "GameConfig_key_idx" ON "GameConfig"("key");

-- CreateIndex
CREATE INDEX "Feedback_fromUserId_idx" ON "Feedback"("fromUserId");

-- CreateIndex
CREATE INDEX "Feedback_toUserId_idx" ON "Feedback"("toUserId");

-- CreateIndex
CREATE INDEX "Feedback_toAgentId_idx" ON "Feedback"("toAgentId");

-- CreateIndex
CREATE INDEX "Feedback_gameId_idx" ON "Feedback"("gameId");

-- CreateIndex
CREATE INDEX "Feedback_interactionType_idx" ON "Feedback"("interactionType");

-- CreateIndex
CREATE INDEX "Feedback_score_idx" ON "Feedback"("score" DESC);

-- CreateIndex
CREATE INDEX "Feedback_createdAt_idx" ON "Feedback"("createdAt" DESC);

-- CreateIndex
CREATE INDEX "Feedback_toUserId_interactionType_idx" ON "Feedback"("toUserId", "interactionType");

-- CreateIndex
CREATE UNIQUE INDEX "AgentPerformanceMetrics_userId_key" ON "AgentPerformanceMetrics"("userId");

-- CreateIndex
CREATE INDEX "AgentPerformanceMetrics_reputationScore_idx" ON "AgentPerformanceMetrics"("reputationScore" DESC);

-- CreateIndex
CREATE INDEX "AgentPerformanceMetrics_normalizedPnL_idx" ON "AgentPerformanceMetrics"("normalizedPnL" DESC);

-- CreateIndex
CREATE INDEX "AgentPerformanceMetrics_trustLevel_idx" ON "AgentPerformanceMetrics"("trustLevel");

-- CreateIndex
CREATE INDEX "AgentPerformanceMetrics_gamesPlayed_idx" ON "AgentPerformanceMetrics"("gamesPlayed" DESC);

-- CreateIndex
CREATE INDEX "AgentPerformanceMetrics_updatedAt_idx" ON "AgentPerformanceMetrics"("updatedAt" DESC);

-- AddForeignKey
ALTER TABLE "OnboardingIntent" ADD CONSTRAINT "OnboardingIntent_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_parentCommentId_fkey" FOREIGN KEY ("parentCommentId") REFERENCES "Comment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reaction" ADD CONSTRAINT "Reaction_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reaction" ADD CONSTRAINT "Reaction_commentId_fkey" FOREIGN KEY ("commentId") REFERENCES "Comment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reaction" ADD CONSTRAINT "Reaction_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Follow" ADD CONSTRAINT "Follow_followerId_fkey" FOREIGN KEY ("followerId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Follow" ADD CONSTRAINT "Follow_followingId_fkey" FOREIGN KEY ("followingId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Favorite" ADD CONSTRAINT "Favorite_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Favorite" ADD CONSTRAINT "Favorite_targetUserId_fkey" FOREIGN KEY ("targetUserId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Share" ADD CONSTRAINT "Share_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Share" ADD CONSTRAINT "Share_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Position" ADD CONSTRAINT "Position_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Position" ADD CONSTRAINT "Position_marketId_fkey" FOREIGN KEY ("marketId") REFERENCES "Market"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Position" ADD CONSTRAINT "Position_questionId_fkey" FOREIGN KEY ("questionId") REFERENCES "Question"("questionNumber") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChatParticipant" ADD CONSTRAINT "ChatParticipant_chatId_fkey" FOREIGN KEY ("chatId") REFERENCES "Chat"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_chatId_fkey" FOREIGN KEY ("chatId") REFERENCES "Chat"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BalanceTransaction" ADD CONSTRAINT "BalanceTransaction_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StockPrice" ADD CONSTRAINT "StockPrice_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ActorFollow" ADD CONSTRAINT "ActorFollow_followerId_fkey" FOREIGN KEY ("followerId") REFERENCES "Actor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ActorFollow" ADD CONSTRAINT "ActorFollow_followingId_fkey" FOREIGN KEY ("followingId") REFERENCES "Actor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserActorFollow" ADD CONSTRAINT "UserActorFollow_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserActorFollow" ADD CONSTRAINT "UserActorFollow_actorId_fkey" FOREIGN KEY ("actorId") REFERENCES "Actor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ActorRelationship" ADD CONSTRAINT "ActorRelationship_actor1Id_fkey" FOREIGN KEY ("actor1Id") REFERENCES "Actor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ActorRelationship" ADD CONSTRAINT "ActorRelationship_actor2Id_fkey" FOREIGN KEY ("actor2Id") REFERENCES "Actor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_actorId_fkey" FOREIGN KEY ("actorId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Pool" ADD CONSTRAINT "Pool_npcActorId_fkey" FOREIGN KEY ("npcActorId") REFERENCES "Actor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PoolDeposit" ADD CONSTRAINT "PoolDeposit_poolId_fkey" FOREIGN KEY ("poolId") REFERENCES "Pool"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PoolPosition" ADD CONSTRAINT "PoolPosition_poolId_fkey" FOREIGN KEY ("poolId") REFERENCES "Pool"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NPCTrade" ADD CONSTRAINT "NPCTrade_npcActorId_fkey" FOREIGN KEY ("npcActorId") REFERENCES "Actor"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NPCTrade" ADD CONSTRAINT "NPCTrade_poolId_fkey" FOREIGN KEY ("poolId") REFERENCES "Pool"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PointsTransaction" ADD CONSTRAINT "PointsTransaction_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Referral" ADD CONSTRAINT "Referral_referrerId_fkey" FOREIGN KEY ("referrerId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Referral" ADD CONSTRAINT "Referral_referredUserId_fkey" FOREIGN KEY ("referredUserId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ShareAction" ADD CONSTRAINT "ShareAction_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TradingFee" ADD CONSTRAINT "TradingFee_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TradingFee" ADD CONSTRAINT "TradingFee_referrerId_fkey" FOREIGN KEY ("referrerId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PostTag" ADD CONSTRAINT "PostTag_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PostTag" ADD CONSTRAINT "PostTag_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TrendingTag" ADD CONSTRAINT "TrendingTag_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Feedback" ADD CONSTRAINT "Feedback_fromUserId_fkey" FOREIGN KEY ("fromUserId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Feedback" ADD CONSTRAINT "Feedback_toUserId_fkey" FOREIGN KEY ("toUserId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AgentPerformanceMetrics" ADD CONSTRAINT "AgentPerformanceMetrics_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
