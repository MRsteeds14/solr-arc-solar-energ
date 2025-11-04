# SOLR-ARC Platform

AI-powered platform that tokenizes solar energy generation, enabling producers to earn sARC tokens (1 kWh = 1 sARC) redeemable for USDC on the Arc blockchain.

## 🌟 Features

- **Instant Tokenization**: Convert solar generation to sARC tokens with AI-powered validation
- **USDC Settlement**: Seamless redemption to USDC on Arc Testnet blockchain
- **AI Automation**: Risk and Proof-of-Generation agents validate and process minting
- **Real-time Dashboard**: Track energy generation, token balances, and transactions
- **Transparent Rates**: Clear exchange rates (1 sARC = 0.10 USDC)

## 🚀 Quick Start

**👉 New to the project? See [QUICKSTART.md](./QUICKSTART.md) for a 5-minute setup guide!**

### Prerequisites

- Node.js 18+ and npm
- Thirdweb Client ID ([Get one here](https://thirdweb.com/dashboard/settings/api-keys))
- Arc Testnet wallet with USDC for gas fees

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/MRsteeds14/solr-arc-solar-energ.git
   cd solr-arc-solar-energ
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure environment**
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` and add your Thirdweb Client ID:
   ```env
   VITE_THIRDWEB_CLIENT_ID=your_client_id_here
   ```

4. **Start development server**
   ```bash
   npm run dev
   ```

## 🔐 Wallet Configuration

This platform uses the **Thirdweb Arc Testnet wallet** (`0x9e7D0d9775d9bacE19B97C8d25C6e572DdbaC072`) for smart contract deployment and interactions.

### Why Thirdweb Instead of Circle?

We chose Thirdweb over Circle's developer-controlled wallet because:

- ✅ Simplified integration with existing Arc Testnet infrastructure
- ✅ Native support for smart contract deployment and management
- ✅ Comprehensive SDK and API with your existing x-client-id
- ✅ Easy contract import and interaction via Thirdweb Dashboard
- ✅ No need for additional wallet setup

**See [DEPLOYMENT.md](./DEPLOYMENT.md) for detailed information** about deploying smart contracts using Thirdweb.

## 📝 Smart Contracts

This repository includes complete Solidity smart contracts in the `contracts/` directory:

- **SARCToken.sol** - ERC20 token for solar energy tokenization (1 kWh = 1 sARC)
- **Registry.sol** - Producer verification and whitelisting system
- **Treasury.sol** - USDC redemption management (1 sARC = 0.10 USDC)
- **MintingController.sol** - Validated energy-to-token minting

### Deploy Your Own Contracts

See **[CONTRACT_DEPLOYMENT_GUIDE.md](./CONTRACT_DEPLOYMENT_GUIDE.md)** for complete deployment instructions using Thirdweb.

### Example Deployed Contracts (Arc Testnet)

- **sARC Token**: `0x9604ad29C8fEe0611EcE73a91e192E5d976E2184`
- **Registry**: `0x742d35Cc6634C0532925a3b844Bc454e4438f44e`
- **Treasury**: `0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199`
- **Minting Controller**: `0xdD2FD4581271e230360230F9337D5c0430Bf44C0`

## 🛠️ Development

### Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm run lint` - Run ESLint

### Project Structure

```
src/
├── components/       # React components
│   ├── dashboard/   # Dashboard widgets
│   ├── minting/     # Energy input and minting UI
│   ├── redemption/  # Token redemption interface
│   ├── wallet/      # Wallet connection components
│   └── ui/          # Reusable UI components
├── lib/             # Utilities and configuration
│   ├── constants.ts # Contract addresses and constants
│   ├── thirdweb.ts  # Thirdweb SDK configuration
│   └── helpers.ts   # Helper functions
└── types/           # TypeScript type definitions
```

## 🔗 Resources

- [Contract Deployment Guide](./CONTRACT_DEPLOYMENT_GUIDE.md) - **Complete step-by-step deployment instructions**
- [Quick Start Guide](./QUICKSTART.md) - Fast setup for development
- [Deployment Overview](./DEPLOYMENT.md) - General deployment information
- [Product Requirements Document (PRD)](./PRD.md) - Detailed feature specifications
- [Thirdweb Documentation](https://portal.thirdweb.com/)
- [Arc Testnet Explorer](https://testnet.arcscan.app)

## 🔒 Security

- Never commit `.env` files with actual credentials
- Protect your Thirdweb x-client-id like a password
- Use environment variables for all sensitive configuration
- Keep wallet private keys secure (hardware wallet recommended)

## 📄 License

The Spark Template files and resources from GitHub are licensed under the terms of the MIT license, Copyright GitHub, Inc.
