# Smart Contract Deployment Guide

## Overview

This guide explains how to deploy and manage smart contracts for the SOLR-ARC platform using the **Thirdweb Arc Testnet wallet** instead of a Circle developer-controlled wallet.

## Wallet Decision: Thirdweb vs Circle

### Why Thirdweb Arc Testnet Wallet?

We've chosen to use the **Thirdweb Arc Testnet wallet** (`0x9e7D0d9775d9bacE19B97C8d25C6e572DdbaC072`) for the following reasons:

1. **Simplified Integration**: Thirdweb provides a comprehensive SDK and dashboard that makes it easier to deploy and manage smart contracts without needing to set up a separate Circle developer-controlled wallet.

2. **Arc Testnet Native**: The Thirdweb wallet is already configured for Arc Testnet, eliminating the need for additional network configuration.

3. **Developer Experience**: With your existing Thirdweb x-client-id, you can leverage the full Thirdweb ecosystem including:
   - Contract deployment tools
   - Transaction monitoring
   - SDK integration for Web3 interactions
   - Dashboard for contract management

4. **Import Existing Contracts**: Thirdweb allows you to import and manage existing smart contracts via their dashboard, making it easy to interact with already deployed contracts.

### Circle Developer-Controlled Wallet (Not Used)

While Circle's developer-controlled wallets (https://developers.circle.com/wallets/dev-controlled/create-your-first-wallet) are powerful for programmatic wallet creation and management, they add unnecessary complexity for this use case where we:
- Already have a working Arc Testnet wallet
- Need to deploy and interact with smart contracts (not create user wallets)
- Have existing Thirdweb infrastructure

## Prerequisites

1. **Thirdweb Client ID**: You mentioned you have your x-client-id. Keep this secure.
2. **Arc Testnet Wallet**: `0x9e7D0d9775d9bacE19B97C8d25C6e572DdbaC072`
3. **Arc Testnet Tokens**: Ensure your wallet has sufficient USDC on Arc Testnet for gas fees

## Configuration

1. Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```

2. Add your Thirdweb Client ID:
```env
VITE_THIRDWEB_CLIENT_ID=your_actual_client_id_here
```

## Smart Contract Addresses

The following contracts are already deployed on Arc Testnet:

- **sARC Token**: `0x9604ad29C8fEe0611EcE73a91e192E5d976E2184`
- **Registry**: `0x742d35Cc6634C0532925a3b844Bc454e4438f44e`
- **Treasury**: `0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199`
- **Minting Controller**: `0xdD2FD4581271e230360230F9337D5c0430Bf44C0`

## Deploying New Contracts via Thirdweb

### Option 1: Thirdweb Dashboard (Recommended)

1. Visit [Thirdweb Dashboard](https://thirdweb.com/dashboard)
2. Connect your wallet (`0x9e7D0d9775d9bacE19B97C8d25C6e572DdbaC072`)
3. Select "Deploy Contract"
4. Choose your contract type or upload custom Solidity code
5. Select "Arc Testnet" as the network
6. Deploy and confirm the transaction

### Option 2: Import Existing Contracts

If you have already deployed contracts and want to manage them via Thirdweb:

1. Go to [Thirdweb Dashboard](https://thirdweb.com/dashboard)
2. Click "Import Contract"
3. Enter the contract address on Arc Testnet
4. Thirdweb will fetch the ABI and allow you to interact with the contract

### Option 3: Thirdweb SDK (Programmatic)

For automated deployments, use the Thirdweb SDK:

```typescript
import { ThirdwebSDK } from "@thirdweb-dev/sdk";

const sdk = ThirdwebSDK.fromPrivateKey(
  process.env.WALLET_PRIVATE_KEY,
  "arc-testnet",
  {
    clientId: process.env.VITE_THIRDWEB_CLIENT_ID,
  }
);

// Deploy a new contract
const address = await sdk.deployer.deployBuiltInContract(
  "token",
  {
    name: "sARC Token",
    symbol: "sARC",
    // ... other parameters
  }
);
```

## Using Thirdweb API

With your x-client-id, you can use the Thirdweb API for various operations:

```javascript
// Example: Get contract info
const response = await fetch(
  `https://api.thirdweb.com/contract/${chainId}/${contractAddress}`,
  {
    headers: {
      'x-client-id': process.env.VITE_THIRDWEB_CLIENT_ID,
    },
  }
);
```

## Integration with SOLR-ARC Platform

The platform is configured to use the Thirdweb Arc Testnet wallet for all blockchain interactions:

1. **Minting sARC Tokens**: When energy is submitted, the platform will call the Minting Controller contract using the Thirdweb wallet
2. **Redemption**: USDC redemptions will be processed through the Treasury contract
3. **Registry**: Producer verification and whitelisting happens via the Registry contract

## Security Considerations

1. **Never commit** your `.env` file with actual credentials to version control
2. **Protect your x-client-id** - treat it like a password
3. **Use environment variables** for all sensitive configuration
4. **Wallet Security**: Ensure the private key for `0x9e7D0d9775d9bacE19B97C8d25C6e572DdbaC072` is stored securely (e.g., hardware wallet, secure key management service)

## Testing

Before deploying to mainnet:

1. Test all contract interactions on Arc Testnet
2. Verify transactions on the Arc Testnet explorer: https://testnet.arcscan.app
3. Monitor gas costs and optimize where needed
4. Test wallet connection flows in the UI

## Resources

- [Thirdweb Documentation](https://portal.thirdweb.com/)
- [Thirdweb API Reference](https://api.thirdweb.com)
- [Arc Testnet Information](https://rpc-testnet.arcchain.org)
- [SOLR-ARC Platform PRD](./PRD.md)

## Support

For issues related to:
- **Thirdweb**: Contact Thirdweb support or check their Discord
- **Arc Testnet**: Check Arc blockchain documentation
- **SOLR-ARC Platform**: Refer to this repository's issues
