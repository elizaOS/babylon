import { NextResponse, type NextRequest } from 'next/server'
import crypto from 'node:crypto'

const isDev = process.env.NODE_ENV !== 'production'

const defaultRpcOrigins = new Set([
  'https://sepolia.base.org',
  'https://mainnet.base.org',
  'https://ethereum-sepolia-rpc.publicnode.com',
])

const rpcEnvCandidates = [
  process.env.NEXT_PUBLIC_RPC_URL,
  process.env.BASE_RPC_URL,
  process.env.BASE_SEPOLIA_RPC_URL,
  process.env.SEPOLIA_RPC_URL,
]

for (const candidate of rpcEnvCandidates) {
  if (!candidate) continue
  try {
    const origin = new URL(candidate).origin
    defaultRpcOrigins.add(origin)
  } catch {
    // Ignore invalid URLs – caught later if truly invalid.
  }
}

function buildContentSecurityPolicy(nonce: string) {
  const scriptSources = [
    "'self'",
    `'nonce-${nonce}'`,
    'https://challenges.cloudflare.com',
    'https://va.vercel-scripts.com',
  ]

  if (isDev) {
    scriptSources.push("'unsafe-inline'", "'unsafe-eval'")
  }

  const connectSources = new Set([
    "'self'",
    'https://auth.privy.io',
    'wss://relay.walletconnect.com',
    'wss://relay.walletconnect.org',
    'wss://www.walletlink.org',
    'https://*.rpc.privy.systems',
    'https://explorer-api.walletconnect.com',
    'https://us.i.posthog.com',
    'https://vitals.vercel-insights.com',
  ])

  for (const origin of defaultRpcOrigins) {
    connectSources.add(origin)
  }

  const directives = [
    "default-src 'self'",
    `script-src ${scriptSources.join(' ')}`,
    "style-src 'self' 'unsafe-inline'",
    "img-src 'self' data: blob: https:",
    "font-src 'self'",
    "object-src 'none'",
    "base-uri 'self'",
    "form-action 'self'",
    "frame-ancestors 'self' https://farcaster.xyz https://*.farcaster.xyz",
    'child-src https://auth.privy.io https://verify.walletconnect.com https://verify.walletconnect.org',
    'frame-src https://auth.privy.io https://verify.walletconnect.com https://verify.walletconnect.org https://challenges.cloudflare.com',
    `connect-src ${Array.from(connectSources).join(' ')}`,
    "worker-src 'self'",
    "manifest-src 'self'",
  ]

  return directives.join('; ')
}

export function middleware(request: NextRequest) {
  const nonce = Buffer.from(crypto.randomUUID()).toString('base64')

  const requestHeaders = new Headers(request.headers)
  requestHeaders.set('x-csp-nonce', nonce)

  const response = NextResponse.next({
    request: {
      headers: requestHeaders,
    },
  })

  response.headers.set('Content-Security-Policy', buildContentSecurityPolicy(nonce))
  response.headers.set('X-Frame-Options', 'SAMEORIGIN')
  response.headers.set('x-csp-nonce', nonce)

  return response
}

export const config = {
  matcher: [
    '/((?!_next/static|_next/image|favicon.ico).*)',
  ],
}
