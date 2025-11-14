export interface ApiFetchOptions extends RequestInit {
  /**
   * When true (default), the current Privy access token is attached if available.
   */
  auth?: boolean;
  /**
   * When true (default), automatically retry with a fresh token if the request fails with 401.
   */
  autoRetryOn401?: boolean;
  /**
   * When true, attach the Privy identity token (if available) for reconciliation flows.
   */
  includeIdentityToken?: boolean;
}

/**
 * Get a fresh Privy access token
 */
async function getPrivyAccessToken(): Promise<string | null> {
  if (typeof window === 'undefined') return null;
  
  // Use the Privy hook's getAccessToken if available
  const privy = (window as typeof window & { __privyGetAccessToken?: () => Promise<string | null> }).__privyGetAccessToken;
  if (privy) {
    const token = await privy();
    // Update the cached token
    (window as typeof window & { __privyAccessToken?: string | null }).__privyAccessToken = token;
    return token;
  }
  
  // Fallback to cached token
  return (window as typeof window & { __privyAccessToken?: string | null }).__privyAccessToken ?? null;
}

/**
 * Lightweight wrapper around fetch that decorates requests with the latest
 * Privy access token stored on window. Centralising this logic avoids
 * sprinkling direct window lookups across the codebase and keeps future
 * Privy integration changes localised.
 * 
 * Automatically retries requests with a fresh token if a 401 error is received.
 */
export async function apiFetch(input: RequestInfo, init: ApiFetchOptions = {}) {
  const { auth = true, autoRetryOn401 = true, headers, includeIdentityToken = false, ...rest } = init;
  const finalHeaders = new Headers(headers ?? {});

  if (auth) {
    const token =
      typeof window !== 'undefined' ? (window as typeof window & { __privyAccessToken?: string | null }).__privyAccessToken : null;
    const identityToken =
      includeIdentityToken && typeof window !== 'undefined'
        ? (window as typeof window & { __privyIdentityToken?: string | null }).__privyIdentityToken
        : null;

    if (token) {
      finalHeaders.set('Authorization', `Bearer ${token}`);
    }

    if (identityToken) {
      finalHeaders.set('X-Privy-Identity-Token', identityToken);
    }
  }

  let response = await fetch(input, {
    ...rest,
    headers: finalHeaders,
  });

  // If we get a 401 and auto-retry is enabled, try to refresh the token and retry
  if (response.status === 401 && auth && autoRetryOn401) {
    const freshToken = await getPrivyAccessToken();
    
    if (freshToken) {
      const retryHeaders = new Headers(headers ?? {});
      retryHeaders.set('Authorization', `Bearer ${freshToken}`);

      const identityToken =
        includeIdentityToken && typeof window !== 'undefined'
          ? (window as typeof window & { __privyIdentityToken?: string | null }).__privyIdentityToken
          : null;

      if (identityToken) {
        retryHeaders.set('X-Privy-Identity-Token', identityToken);
      }

      response = await fetch(input, {
        ...rest,
        headers: retryHeaders,
      });
    }
  }

  return response;
}
