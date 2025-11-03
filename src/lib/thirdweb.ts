/**
 * Thirdweb Configuration and Utilities
 * 
 * This file contains configuration for Thirdweb SDK integration
 * which enables smart contract deployment and interaction on Arc Testnet
 * without requiring a Circle developer-controlled wallet.
 * 
 * See DEPLOYMENT.md for more information about the wallet architecture decision.
 */

import { ARC_TESTNET, THIRDWEB_ARC_WALLET, CONTRACTS } from './constants'

/**
 * Thirdweb Client ID from environment variables
 * Get yours from: https://thirdweb.com/dashboard/settings/api-keys
 */
export const THIRDWEB_CLIENT_ID = import.meta.env.VITE_THIRDWEB_CLIENT_ID || ''

/**
 * Validate that the Thirdweb client ID is configured before making API calls
 */
function validateClientId(): void {
  if (!THIRDWEB_CLIENT_ID) {
    throw new Error(
      'VITE_THIRDWEB_CLIENT_ID is not configured. Please set it in your .env file. See .env.example for details.'
    )
  }
}

/**
 * Chain configuration for Thirdweb SDK
 */
export const thirdwebChainConfig = {
  chainId: ARC_TESTNET.chainId,
  name: ARC_TESTNET.name,
  rpc: [ARC_TESTNET.rpcUrl],
  nativeCurrency: ARC_TESTNET.nativeCurrency,
  blockExplorers: [
    {
      name: 'Arc Testnet Explorer',
      url: ARC_TESTNET.blockExplorer,
    },
  ],
  testnet: true,
}

/**
 * Wallet configuration
 */
export const walletConfig = {
  address: THIRDWEB_ARC_WALLET,
  network: ARC_TESTNET.name,
  chainId: ARC_TESTNET.chainId,
}

/**
 * Contract configuration for Thirdweb interactions
 */
export const contractConfig = {
  sarcToken: {
    address: CONTRACTS.SARC_TOKEN,
    chain: thirdwebChainConfig,
  },
  registry: {
    address: CONTRACTS.REGISTRY,
    chain: thirdwebChainConfig,
  },
  treasury: {
    address: CONTRACTS.TREASURY,
    chain: thirdwebChainConfig,
  },
  mintingController: {
    address: CONTRACTS.MINTING_CONTROLLER,
    chain: thirdwebChainConfig,
  },
}

/**
 * Thirdweb API base URL
 */
export const THIRDWEB_API_BASE = 'https://api.thirdweb.com'

/**
 * Helper to make Thirdweb API requests with client ID
 */
export async function thirdwebApiRequest(
  endpoint: string,
  options: RequestInit = {}
): Promise<Response> {
  // Validate client ID before making API requests
  validateClientId()

  const headers = {
    'x-client-id': THIRDWEB_CLIENT_ID,
    'Content-Type': 'application/json',
    ...options.headers,
  }

  return fetch(`${THIRDWEB_API_BASE}${endpoint}`, {
    ...options,
    headers,
  })
}

/**
 * Get contract information from Thirdweb API
 */
export async function getContractInfo(contractAddress: string) {
  try {
    const response = await thirdwebApiRequest(
      `/contract/${ARC_TESTNET.chainId}/${contractAddress}`
    )
    return await response.json()
  } catch (error) {
    console.error('Error fetching contract info:', error)
    return null
  }
}

/**
 * Verify that Thirdweb is properly configured
 */
export function isThirdwebConfigured(): boolean {
  return Boolean(THIRDWEB_CLIENT_ID)
}

/**
 * Get configuration warnings for developers
 */
export function getConfigWarnings(): string[] {
  const warnings: string[] = []

  if (!THIRDWEB_CLIENT_ID) {
    warnings.push(
      'VITE_THIRDWEB_CLIENT_ID is not set. Please add it to your .env file. See .env.example for details.'
    )
  }

  return warnings
}
