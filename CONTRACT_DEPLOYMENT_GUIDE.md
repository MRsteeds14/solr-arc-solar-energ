# Complete Smart Contract Deployment Guide

This guide provides step-by-step instructions for deploying the SOLR-ARC smart contracts to Arc Testnet using Thirdweb.

## 📋 Prerequisites

Before you begin, ensure you have:

1. ✅ **Thirdweb Account** with your x-client-id
2. ✅ **Arc Testnet Wallet** (`0x9e7D0d9775d9bacE19B97C8d25C6e572DdbaC072`)
3. ✅ **USDC on Arc Testnet** for gas fees
4. ✅ **Node.js 18+** and npm installed
5. ✅ **This repository cloned** locally

## 🎯 What This Guide Covers

This repository now includes complete Solidity smart contracts:

- **`contracts/SARCToken.sol`** - ERC20 token for solar energy (1 kWh = 1 sARC)
- **`contracts/Registry.sol`** - Producer verification and whitelisting
- **`contracts/Treasury.sol`** - USDC redemption management (1 sARC = 0.10 USDC)
- **`contracts/MintingController.sol`** - Validated energy-to-token minting

## 📦 Deployment Methods

Choose one of these methods to deploy your contracts:

### Method 1: Using Thirdweb CLI (Recommended)

This is the easiest method and integrates directly with your Thirdweb account.

#### Step 1: Install Thirdweb CLI

```bash
npm install -g @thirdweb-dev/cli
```

#### Step 2: Deploy Contracts

From the repository root directory:

```bash
# Deploy all contracts to Arc Testnet
npx thirdweb deploy

# This will:
# 1. Compile your Solidity contracts
# 2. Open a browser to connect your wallet
# 3. Let you configure deployment parameters
# 4. Deploy to Arc Testnet
```

#### Step 3: Follow the Interactive Process

The Thirdweb dashboard will guide you through:

1. **Select Network**: Choose "Arc Testnet" (Chain ID: 1234)
2. **Connect Wallet**: Connect your Thirdweb Arc Testnet wallet
3. **Deploy Contracts**: Deploy in this order:
   - First: `SARCToken`
   - Second: `Registry`
   - Third: `MintingController` (provide SARCToken and Registry addresses)
   - Fourth: `Treasury` (provide SARCToken and USDC addresses)

#### Step 4: Configure Permissions

After deployment, you need to grant the MintingController permission to mint tokens:

```bash
# Use Thirdweb dashboard to call:
# SARCToken.grantMinterRole(MintingControllerAddress)
```

Or use the Thirdweb SDK/API to call this function programmatically.

### Method 2: Using Hardhat (For Advanced Users)

If you prefer command-line deployment:

#### Step 1: Configure Environment

Create a `.env` file:

```bash
cp .env.example .env
```

Add your private key:

```env
PRIVATE_KEY=your_wallet_private_key_here
VITE_THIRDWEB_CLIENT_ID=your_thirdweb_client_id_here
```

⚠️ **NEVER commit your `.env` file to version control!**

#### Step 2: Install Dependencies

```bash
npm install
```

#### Step 3: Compile Contracts

```bash
npx hardhat compile
```

#### Step 4: Deploy to Arc Testnet

```bash
npx hardhat run scripts/deploy.js --network arcTestnet
```

This will deploy all contracts and print their addresses.

#### Step 5: Register a Producer

Update `scripts/register-producer.js` with deployed addresses, then run:

```bash
npx hardhat run scripts/register-producer.js --network arcTestnet
```

### Method 3: Using Thirdweb Dashboard (No Code)

Perfect if you don't want to use the command line:

#### Step 1: Go to Thirdweb Dashboard

Visit [thirdweb.com/dashboard](https://thirdweb.com/dashboard)

#### Step 2: Deploy Contracts

1. Click **"Deploy Contract"**
2. Select **"Import Contract"**
3. Upload the contract files from the `contracts/` directory one at a time
4. Choose **"Arc Testnet"** as the network
5. Configure constructor parameters:
   - **SARCToken**: No parameters needed
   - **Registry**: No parameters needed
   - **MintingController**: Requires `sarcToken` and `registry` addresses
   - **Treasury**: Requires `sarcToken` and `usdcToken` addresses

#### Step 3: Set Permissions

Use the dashboard to call:
- `SARCToken.grantMinterRole(mintingControllerAddress)`

## 🔗 Contract Addresses

After deployment, update `src/lib/constants.ts` with your new contract addresses:

```typescript
export const CONTRACTS = {
  SARC_TOKEN: '0xYourSARCTokenAddress',
  REGISTRY: '0xYourRegistryAddress',
  TREASURY: '0xYourTreasuryAddress',
  MINTING_CONTROLLER: '0xYourMintingControllerAddress',
} as const
```

## 🧪 Testing Your Deployment

### 1. Register a Producer

Using Thirdweb Dashboard:
1. Go to your Registry contract
2. Call `registerProducer` with:
   - `producer`: Your wallet address
   - `systemCapacityKW`: 10 (example)
   - `dailyCapKWh`: 100 (example)
   - `metadata`: JSON metadata string

### 2. Test Minting

Using Thirdweb Dashboard:
1. Go to your MintingController contract
2. Call `submitEnergy` with:
   - `producer`: Your registered wallet address
   - `kwhAmount`: Amount in wei (e.g., `1000000000000000000` for 1 kWh)
   - `ipfsHash`: Any string (e.g., "QmTest123")

### 3. Verify Token Balance

1. Go to your SARCToken contract
2. Call `balanceOf` with your wallet address
3. You should see the minted tokens!

## 📝 Important Notes

### USDC Token Address

The Treasury contract requires a USDC token address. You'll need to:

1. Find the official USDC contract on Arc Testnet, OR
2. Deploy a mock USDC token for testing, OR
3. Use a placeholder and update it later

### Gas Fees

Ensure your wallet has sufficient USDC for:
- Contract deployment gas fees
- Transaction gas fees for minting and redemption

### Security Best Practices

1. **Private Keys**: Never expose your private key
2. **Environment Variables**: Always use `.env` files for sensitive data
3. **Contract Verification**: Verify contracts on Arc block explorer after deployment
4. **Test First**: Deploy to a testnet before mainnet

## 🔍 Verifying Contracts

After deployment, verify your contracts on Arc Testnet explorer:

### Using Thirdweb

Thirdweb automatically verifies contracts when you deploy through their platform.

### Using Hardhat

```bash
npx hardhat verify --network arcTestnet <CONTRACT_ADDRESS> [CONSTRUCTOR_ARGS]
```

Example:
```bash
npx hardhat verify --network arcTestnet 0xYourSARCTokenAddress
npx hardhat verify --network arcTestnet 0xYourRegistryAddress
npx hardhat verify --network arcTestnet 0xYourMintingControllerAddress 0xSARCTokenAddress 0xRegistryAddress
```

## 🆘 Troubleshooting

### "Insufficient funds" Error

Ensure your wallet has enough USDC for gas fees on Arc Testnet.

### "Producer not verified" Error

You need to register the producer in the Registry contract before minting.

### "Exceeds daily generation cap" Error

The producer has reached their daily minting limit. Wait until the next day (UTC).

### Contract Not Found

Double-check that you're using the correct contract addresses and network.

## 📚 Additional Resources

- [Thirdweb Documentation](https://portal.thirdweb.com/)
- [Thirdweb Deploy Guide](https://portal.thirdweb.com/deploy)
- [Hardhat Documentation](https://hardhat.org/docs)
- [Arc Testnet Explorer](https://testnet.arcscan.app)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)

## 🎉 Next Steps

After successful deployment:

1. ✅ Update `src/lib/constants.ts` with contract addresses
2. ✅ Register producers in the Registry
3. ✅ Fund Treasury with USDC for redemptions
4. ✅ Test minting and redemption flows
5. ✅ Update documentation with your contract addresses
6. ✅ Deploy frontend to demonstrate the platform

## 💡 Tips

- **Use Thirdweb Dashboard** for the easiest deployment experience
- **Keep deployment logs** with all contract addresses
- **Test thoroughly** on testnet before any mainnet deployment
- **Monitor gas costs** and optimize if needed
- **Import contracts** into Thirdweb Dashboard for easy interaction

---

**Need Help?** Check the other guides:
- [QUICKSTART.md](./QUICKSTART.md) - Quick setup guide
- [DEPLOYMENT.md](./DEPLOYMENT.md) - General deployment information
- [README.md](./README.md) - Project overview
