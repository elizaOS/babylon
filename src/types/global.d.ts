export {}

declare global {
  interface Window {
    __privyAccessToken?: string | null
    __privyIdentityToken?: string | null
    __privyGetAccessToken?: () => Promise<string | null>
    __privyGetIdentityToken?: () => Promise<string | null>
  }
}
