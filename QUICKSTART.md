# Quick Start Guide: Thirdweb Arc Testnet Wallet Setup

This guide helps you get started quickly with deploying smart contracts using your Thirdweb Arc Testnet wallet.

## 🎯 What You Need

✅ Your Thirdweb Arc Testnet wallet: `0x9e7D0d9775d9bacE19B97C8d25C6e572DdbaC072`  
✅ Your Thirdweb x-client-id (you mentioned you have this)  
✅ This repository cloned locally

## 🚀 5-Minute Setup

### Step 1: Configure Your Environment

```bash
# Copy the example environment file
cp .env.example .env
```

Edit `.env` and add your Thirdweb client ID:

```env
VITE_THIRDWEB_CLIENT_ID=your_actual_x_client_id_here
```

### Step 2: Install Dependencies

```bash
npm install
```

### Step 3: Start the Development Server

```bash
npm run dev
```

The app will open at `http://localhost:5173` (or another port if 5173 is busy).

## ✅ You're Using the Right Wallet!

**Good news**: You can absolutely use your Thirdweb Arc Testnet wallet (`0x9e7D0d9775d9bacE19B97C8d25C6e572DdbaC072`) instead of creating a Circle developer-controlled wallet.

### Why This Works Better

- **Already Configured**: Your wallet is already set up for Arc Testnet
- **Native Integration**: Thirdweb has excellent tools for contract deployment
- **Simpler Flow**: No need to create and manage a separate wallet service
- **You Have the Keys**: Your x-client-id gives you full access to Thirdweb's API and SDK

## 📝 Deploying Smart Contracts

### Option A: Use Thirdweb Dashboard (Easiest)

1. Go to [thirdweb.com/dashboard](https://thirdweb.com/dashboard)
2. Connect your wallet `0x9e7D0d9775d9bacE19B97C8d25C6e572DdbaC072`
3. Click "Deploy Contract"
4. Select "Arc Testnet" as the network
5. Deploy!

### Option B: Import Existing Contracts

Already have contracts deployed? Import them:

1. Go to [thirdweb.com/dashboard](https://thirdweb.com/dashboard)
2. Click "Import Contract"
3. Enter your contract address
4. Thirdweb will fetch the ABI and let you interact with it

### Option C: Use the Thirdweb API

With your x-client-id, you can make API calls:

```javascript
// Example: Get contract info
const response = await fetch(
  'https://api.thirdweb.com/contract/1234/0x9604ad29C8fEe0611EcE73a91e192E5d976E2184',
  {
    headers: {
      'x-client-id': process.env.VITE_THIRDWEB_CLIENT_ID,
    },
  }
);
```

## 🔍 Verifying Everything Works

1. **Check the UI**: You should see a configuration warning if `VITE_THIRDWEB_CLIENT_ID` is not set
2. **Connect Wallet**: The demo uses your Thirdweb wallet address by default
3. **View Contracts**: All contract addresses are displayed in the dashboard

## 🎨 Current Contract Addresses

These contracts are already deployed on Arc Testnet and configured in the app:

- **sARC Token**: `0x9604ad29C8fEe0611EcE73a91e192E5d976E2184`
- **Registry**: `0x742d35Cc6634C0532925a3b844Bc454e4438f44e`
- **Treasury**: `0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199`
- **Minting Controller**: `0xdD2FD4581271e230360230F9337D5c0430Bf44C0`

You can import these into Thirdweb Dashboard to interact with them.

## ❓ Common Questions

### Do I need a Circle developer-controlled wallet?

**No!** Your Thirdweb Arc Testnet wallet is perfect for this use case. Circle's developer-controlled wallets are designed for creating and managing user wallets programmatically, which isn't what you need here.

### What if I need to deploy new contracts?

Use Thirdweb Dashboard or their SDK. See [DEPLOYMENT.md](./DEPLOYMENT.md) for detailed instructions.

### Can I use this in production?

This setup is for Arc Testnet. For production on Arc Mainnet:
1. Ensure your wallet has mainnet tokens
2. Update the chain ID in configuration
3. Deploy contracts to mainnet
4. Update contract addresses in `src/lib/constants.ts`

## 📚 Next Steps

- **Full Documentation**: See [DEPLOYMENT.md](./DEPLOYMENT.md) for comprehensive deployment guide
- **Product Specs**: Check [PRD.md](./PRD.md) for feature details
- **Thirdweb Docs**: Visit [portal.thirdweb.com](https://portal.thirdweb.com/)

## 🆘 Need Help?

- **Thirdweb Issues**: Check their [Discord](https://discord.gg/thirdweb) or [docs](https://portal.thirdweb.com/)
- **Repository Issues**: Open an issue on this repo
- **Arc Testnet**: Check Arc blockchain documentation

---

**You're all set! 🎉** Your Thirdweb wallet is the perfect tool for deploying and managing your SOLR-ARC smart contracts.
