import { beforeAll, beforeEach, describe, expect, it, vi } from 'vitest'
import type { NextRequest } from 'next/server'

const mockVerifyAgentSession = vi.fn()
const mockVerifyAuthToken = vi.fn()
const mockFindUnique = vi.fn()
const mockFindFirst = vi.fn()
const mockUpdate = vi.fn()
const mockGetUser = vi.fn()

vi.mock('@/lib/auth/agent-auth', () => ({
  verifyAgentSession: mockVerifyAgentSession,
}))

vi.mock('@/lib/database-service', () => ({
  prisma: {
    user: {
      findUnique: mockFindUnique,
      findFirst: mockFindFirst,
      update: mockUpdate,
    },
  },
}))

vi.mock('@privy-io/server-auth', () => ({
  PrivyClient: vi.fn().mockImplementation(() => ({
    verifyAuthToken: mockVerifyAuthToken,
    getUser: mockGetUser,
  })),
}))

const createRequest = (token: string, identityToken?: string) =>
  ({
    headers: {
      get: (name: string) => {
        const lower = name.toLowerCase()
        if (lower === 'authorization') {
          return `Bearer ${token}`
        }
        if (lower === 'x-privy-identity-token') {
          return identityToken ?? null
        }
        return null
      },
    },
    cookies: {
      get: () => undefined,
    },
  }) as unknown as NextRequest

describe('authenticate middleware', () => {
  let authenticate: (request: NextRequest) => Promise<unknown>

  beforeAll(async () => {
    ;({ authenticate } = await import('../auth-middleware'))
  })

  beforeEach(() => {
    mockVerifyAgentSession.mockReset()
    mockVerifyAuthToken.mockReset()
    mockFindUnique.mockReset()
    mockFindFirst.mockReset()
    mockUpdate.mockReset()
    mockGetUser.mockReset()
    process.env.NEXT_PUBLIC_PRIVY_APP_ID = 'test-app'
    process.env.PRIVY_APP_SECRET = 'test-secret'
  })

  it('returns agent user when session token is valid', async () => {
    mockVerifyAgentSession.mockReturnValueOnce({ agentId: 'agent-123' })

    const request = createRequest('agent-session-token')
    const result = await authenticate(request)

    expect(result).toEqual({
      userId: 'agent-123',
      privyId: 'agent-123',
      isAgent: true,
    })
    expect(mockVerifyAuthToken).not.toHaveBeenCalled()
    expect(mockFindUnique).not.toHaveBeenCalled()
  })

  it('falls back to privy claims when agent session missing and db user absent', async () => {
    mockVerifyAgentSession.mockReturnValueOnce(null)
    mockVerifyAuthToken.mockResolvedValueOnce({ userId: 'privy-user' })
    mockFindUnique.mockResolvedValueOnce(null)

    const request = createRequest('privy-token')
    const result = await authenticate(request)

    expect(result).toMatchObject({
      userId: 'privy-user',
      dbUserId: undefined,
      privyId: 'privy-user',
      isAgent: false,
    })
  })

  it('returns canonical id when privy user exists in db', async () => {
    mockVerifyAgentSession.mockReturnValueOnce(null)
    mockVerifyAuthToken.mockResolvedValueOnce({ userId: 'privy-user' })
    mockFindUnique.mockResolvedValueOnce({
      id: 'db-user-id',
      walletAddress: '0xabc',
    })

    const request = createRequest('privy-token')
    const result = await authenticate(request)

    expect(result).toMatchObject({
      userId: 'db-user-id',
      dbUserId: 'db-user-id',
      privyId: 'privy-user',
      walletAddress: '0xabc',
    })
  })

  it('throws descriptive error when privy token is expired', async () => {
    mockVerifyAgentSession.mockReturnValueOnce(null)
    mockVerifyAuthToken.mockRejectedValueOnce(new Error('token expired: exp mismatch'))

    const request = createRequest('expired-token')

    await expect(authenticate(request)).rejects.toMatchObject({
      message: 'Authentication token has expired. Please refresh your session.',
      code: 'AUTH_FAILED',
    })
  })

  it('re-links legacy users via wallet or email when privyId changes', async () => {
    mockVerifyAgentSession.mockReturnValueOnce(null)
    mockVerifyAuthToken.mockResolvedValueOnce({ userId: 'new-privy-id' })
    mockFindUnique.mockResolvedValueOnce(null)
    mockGetUser.mockResolvedValueOnce({
      id: 'new-privy-id',
      createdAt: new Date(),
      isGuest: false,
      customMetadata: {},
      linkedAccounts: [],
      wallet: {
        address: '0xlegacy',
      },
      smartWallet: undefined,
      email: undefined,
      google: undefined,
      twitter: undefined,
      discord: undefined,
      github: undefined,
      apple: undefined,
      linkedin: undefined,
    } as unknown)
    mockFindFirst.mockResolvedValueOnce({
      id: 'legacy-user',
      walletAddress: '0xlegacy',
    })
    mockUpdate.mockResolvedValueOnce({})

    const request = createRequest('privy-token', 'identity-token')
    const result = await authenticate(request)

    expect(result).toMatchObject({
      userId: 'legacy-user',
      dbUserId: 'legacy-user',
      privyId: 'new-privy-id',
    })
    expect(mockFindFirst).toHaveBeenCalled()
    expect(mockUpdate).toHaveBeenCalledWith({
      where: { id: 'legacy-user' },
      data: { privyId: 'new-privy-id' },
    })
    expect(mockGetUser).toHaveBeenCalledTimes(1)
    expect(mockGetUser).toHaveBeenCalledWith({ idToken: 'identity-token' })
  })

  it('falls back to Privy user lookup when no identity token is supplied', async () => {
    mockVerifyAgentSession.mockReturnValueOnce(null)
    mockVerifyAuthToken.mockResolvedValueOnce({ userId: 'new-privy-id' })
    mockFindUnique.mockResolvedValueOnce(null)
    mockGetUser.mockResolvedValueOnce({
      id: 'legacy-user',
      walletAddress: '0xlegacy',
      wallet: {
        address: '0xlegacy',
      },
    })
    mockFindFirst.mockResolvedValueOnce({
      id: 'legacy-user',
      walletAddress: '0xlegacy',
    })
    mockUpdate.mockResolvedValueOnce({})

    const request = createRequest('privy-token')
    const result = await authenticate(request)

    expect(result).toMatchObject({
      userId: 'legacy-user',
      dbUserId: 'legacy-user',
      privyId: 'new-privy-id',
    })
    expect(mockGetUser).toHaveBeenCalledWith('new-privy-id')
  })
})
