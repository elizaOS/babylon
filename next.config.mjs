const isProd = process.env.NODE_ENV === 'production'

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
    // Ignore invalid URLs – they will be caught at runtime if misconfigured.
  }
}

const scriptSources = [
  "'self'",
  'https://challenges.cloudflare.com',
  'https://va.vercel-scripts.com',
]

if (!isProd) {
  scriptSources.push("'unsafe-eval'", "'unsafe-inline'")
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

const ContentSecurityPolicy = [
  "default-src 'self'",
  `script-src ${scriptSources.join(' ')}`,
  "style-src 'self' 'unsafe-inline'",
  "img-src 'self' data: blob: https:",
  "font-src 'self'",
  "object-src 'none'",
  "base-uri 'self'",
  "form-action 'self'",
  'frame-ancestors \'self\' https://farcaster.xyz https://*.farcaster.xyz',
  'child-src https://auth.privy.io https://verify.walletconnect.com https://verify.walletconnect.org',
  'frame-src https://auth.privy.io https://verify.walletconnect.com https://verify.walletconnect.org https://challenges.cloudflare.com',
  `connect-src ${Array.from(connectSources).join(' ')}`,
  "worker-src 'self'",
  "manifest-src 'self'",
].join('; ')

const securityHeaders = [
  {
    key: 'Content-Security-Policy',
    value: ContentSecurityPolicy.replace(/\s{2,}/g, ' ').trim(),
  },
  {
    key: 'X-Frame-Options',
    value: 'SAMEORIGIN',
  },
]

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  // Specify workspace root to silence lockfile warning
  outputFileTracingRoot: process.cwd(),
  // Use standalone output for dynamic routes and API endpoints
  // Temporarily disabled for Next.js 16 compatibility
  // output: 'standalone',
  experimental: {
    optimizePackageImports: ['lucide-react'],
    // instrumentationHook removed - available by default in Next.js 15+
  },
  // Skip prerendering for feed page (client-side only)
  skipTrailingSlashRedirect: true,
  skipProxyUrlNormalize: false,
  // Externalize packages with native Node.js dependencies for server-side
  serverExternalPackages: [
    'ipfs-http-client',
    '@helia/unixfs',
    'helia',
    'blockstore-core',
    'datastore-core',
    '@libp2p/interface',
    'electron-fetch',
  ],
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: '**',
      },
    ],
  },
  // Empty turbopack config to silence webpack/turbopack warning
  turbopack: {},
  // Webpack configuration for backward compatibility
  webpack: (config, { isServer }) => {
    // Fix for IPFS, electron-fetch, and React Native dependencies
    config.resolve.fallback = {
      ...config.resolve.fallback,
      electron: false,
      fs: false,
      net: false,
      tls: false,
      '@react-native-async-storage/async-storage': false,
    };

    // Externalize electron-fetch for server-side
    if (isServer) {
      config.externals.push('electron');
    }

    return config;
  },
  async headers() {
    return [
      {
        source: '/:path*',
        headers: securityHeaders,
      },
    ]
  },
}

export default nextConfig
