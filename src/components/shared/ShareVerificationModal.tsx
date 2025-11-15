'use client'

import { useState } from 'react'
import { X as XIcon, Check } from 'lucide-react'
import { cn } from '@/lib/utils'
import { toast } from 'sonner'

interface ShareVerificationModalProps {
  isOpen: boolean
  onClose: () => void
  shareId: string
  platform: 'twitter' | 'farcaster'
  userId: string
}

export function ShareVerificationModal({ 
  isOpen, 
  onClose, 
  shareId, 
  platform,
  userId 
}: ShareVerificationModalProps) {
  const [postUrl, setPostUrl] = useState('')
  const [verifying, setVerifying] = useState(false)

  if (!isOpen) return null

  const handleVerify = async () => {
    if (!postUrl.trim()) {
      toast.error('Please enter the URL to your post')
      return
    }

    setVerifying(true)

    const token = typeof window !== 'undefined' ? window.__privyAccessToken : null
    const headers: HeadersInit = {
      'Content-Type': 'application/json',
    }
    if (token) {
      headers['Authorization'] = `Bearer ${token}`
    }

    try {
      const response = await fetch(`/api/users/${encodeURIComponent(userId)}/verify-share`, {
        method: 'POST',
        headers,
        body: JSON.stringify({
          shareId,
          platform,
          postUrl: postUrl.trim(),
        }),
      })

      const data = await response.json()

      if (!response.ok) {
        toast.error(data.message || data.error || 'Failed to verify share')
        setVerifying(false)
        return
      }

      if (data.verified) {
        const pointsMessage = data.points?.awarded > 0 
          ? `Share verified! You earned ${data.points.awarded} points.` 
          : 'Share verified! Thank you for sharing!'
        toast.success(pointsMessage)
        onClose()
        // Reload the page to update points display
        window.location.reload()
      } else {
        toast.error(data.message || 'Could not verify your post. Please check the URL.')
      }
    } catch (error) {
      toast.error(`An error occurred while verifying. Please try again. ${error instanceof Error ? error.message : 'Unknown error'}`)
    } finally {
      setVerifying(false)
    }
  }

  const platformName = platform === 'twitter' ? 'X' : 'Farcaster'
  const placeholderUrl = platform === 'twitter' 
    ? 'https://twitter.com/username/status/1234567890'
    : 'https://warpcast.com/username/0xabcdef...'

  return (
    <div className="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div className="bg-background rounded-xl max-w-md w-full border border-border">
        {/* Header */}
        <div className="flex items-center justify-between p-6 border-b border-border">
          <h2 className="text-xl font-bold">Verify Your Share</h2>
          <button
            onClick={onClose}
            className="p-2 hover:bg-muted rounded-lg transition-colors"
          >
            <XIcon className="w-5 h-5" />
          </button>
        </div>

        {/* Content */}
        <div className="p-6 space-y-4">
          {/* Points Reward Banner */}
          <div className="p-4 rounded-lg bg-gradient-to-r from-primary/20 to-primary/10 border border-primary/30">
            <div className="flex items-center gap-2 mb-1">
              <span className="text-2xl">🎁</span>
              <h3 className="font-bold text-foreground">Earn 1,000 Points</h3>
            </div>
            <p className="text-xs text-muted-foreground">
              Verify your {platformName} post to earn your reward!
            </p>
          </div>

          <div>
            <p className="text-sm text-muted-foreground mb-4">
              Paste the URL to your {platformName} post below to verify and earn points.
            </p>
            
            <label htmlFor="postUrl" className="block text-sm font-medium mb-2">
              Post URL <span className="text-red-500">*</span>
            </label>
            <input
              id="postUrl"
              type="url"
              value={postUrl}
              onChange={(e) => setPostUrl(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === 'Enter') handleVerify()
              }}
              placeholder={placeholderUrl}
              className="w-full px-4 py-2 rounded-lg bg-sidebar-accent/50 focus:outline-none focus:border-border border border-border/50"
              disabled={verifying}
              required
            />
          </div>

          <div className="p-3 rounded-lg bg-muted/50 border border-border/50">
            <p className="text-xs text-muted-foreground">
              <strong>How to get the URL:</strong> After posting, copy the URL from your browser&apos;s address bar or use the &quot;Copy link&quot; option on your post.
            </p>
          </div>

          <div className="flex gap-2">
            <button
              onClick={handleVerify}
              disabled={verifying || !postUrl.trim()}
              className={cn(
                'flex-1 px-4 py-3 rounded-lg font-semibold transition-colors',
                'bg-primary text-primary-foreground hover:bg-primary/90',
                'disabled:opacity-50 disabled:cursor-not-allowed',
                'flex items-center justify-center gap-2'
              )}
            >
              {verifying ? (
                <>
                  <span className="animate-spin">⏳</span>
                  <span>Verifying...</span>
                </>
              ) : (
                <>
                  <Check className="w-4 h-4" />
                  <span>Verify & Earn Points</span>
                </>
              )}
            </button>
            
            <button
              onClick={onClose}
              disabled={verifying}
              className="px-4 py-3 rounded-lg bg-muted hover:bg-muted/70 font-semibold transition-colors text-sm"
            >
              Skip
            </button>
          </div>

          <p className="text-xs text-center text-muted-foreground">
            ⚠️ You must verify to earn points. Skipping means no reward.
          </p>
        </div>
      </div>
    </div>
  )
}

