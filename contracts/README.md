# SOLR-ARC Smart Contracts

This directory contains the Solidity smart contracts for the SOLR-ARC platform.

## 📁 Contract Files

### SARCToken.sol
**Purpose**: ERC20 token representing solar energy generation  
**Conversion**: 1 kWh = 1 sARC token  
**Features**:
- Standard ERC20 functionality
- Role-based minting (only MintingController can mint)
- Tracks IPFS hash for each minting event

### Registry.sol
**Purpose**: Manages producer verification and whitelisting  
**Features**:
- Register solar producers with system capacity and daily limits
- Verify/unverify producers
- Store producer metadata (IPFS hashes, JSON)
- Query producer information

### Treasury.sol
**Purpose**: Handles USDC redemption for sARC tokens  
**Exchange Rate**: 1 sARC = 0.10 USDC  
**Features**:
- Redeem sARC for USDC
- Calculate USDC amounts
- Manage treasury USDC balance
- Owner can deposit/withdraw USDC

### MintingController.sol
**Purpose**: Controls the minting of sARC tokens based on validated energy generation  
**Features**:
- Submit energy generation data
- Verify producer is registered
- Enforce daily generation caps
- Mint tokens to producers
- Track daily minting amounts

## 🔗 Contract Dependencies

```
SARCToken
    └── (uses) @openzeppelin/contracts/token/ERC20/ERC20.sol
    └── (uses) @openzeppelin/contracts/access/AccessControl.sol

Registry
    └── (uses) @openzeppelin/contracts/access/Ownable.sol

Treasury
    └── (uses) @openzeppelin/contracts/token/ERC20/IERC20.sol
    └── (uses) @openzeppelin/contracts/access/Ownable.sol
    └── (interacts with) SARCToken

MintingController
    └── (uses) @openzeppelin/contracts/access/Ownable.sol
    └── (interacts with) SARCToken
    └── (interacts with) Registry
```

## 🚀 Deployment Order

Contracts must be deployed in this specific order:

1. **SARCToken** (no dependencies)
2. **Registry** (no dependencies)
3. **MintingController** (requires SARCToken and Registry addresses)
4. **Treasury** (requires SARCToken and USDC token addresses)

After deployment:
- Grant MINTER_ROLE to MintingController on SARCToken
- Register producers in Registry
- Fund Treasury with USDC

## 🔐 Access Control

### SARCToken
- **DEFAULT_ADMIN_ROLE**: Can grant/revoke MINTER_ROLE
- **MINTER_ROLE**: Can mint new tokens (should be MintingController)

### Registry
- **Owner**: Can register/verify producers

### Treasury
- **Owner**: Can withdraw USDC from treasury
- **Anyone**: Can redeem sARC for USDC

### MintingController
- **Owner**: Can configure (future enhancements)
- **Anyone**: Can submit energy if they are a verified producer

## 📖 Usage Examples

### Deploying with Thirdweb

See [CONTRACT_DEPLOYMENT_GUIDE.md](../CONTRACT_DEPLOYMENT_GUIDE.md) for complete instructions.

### Interacting with Contracts

#### Register a Producer
```solidity
Registry.registerProducer(
    address producer,
    uint256 systemCapacityKW,  // e.g., 10
    uint256 dailyCapKWh,        // e.g., 100
    string memory metadata       // IPFS hash or JSON
);
```

#### Submit Energy Generation
```solidity
MintingController.submitEnergy(
    address producer,
    uint256 kwhAmount,    // in wei, e.g., 1e18 for 1 kWh
    string memory ipfsHash // proof document hash
);
```

#### Redeem sARC for USDC
```solidity
Treasury.redeem(
    uint256 sarcAmount    // amount of sARC to redeem
);
```

## 🧪 Testing

The contracts use OpenZeppelin's audited libraries for security and reliability.

Key test scenarios:
1. Token minting with proper authorization
2. Producer registration and verification
3. Daily cap enforcement
4. USDC redemption calculations
5. Access control restrictions

## 🔍 Contract Verification

After deploying to Arc Testnet, verify your contracts:

```bash
npx hardhat verify --network arcTestnet <CONTRACT_ADDRESS> [CONSTRUCTOR_ARGS]
```

## 📝 Notes

- **USDC Address**: Treasury requires the USDC token address on Arc Testnet
- **Daily Caps**: Reset at midnight UTC based on `block.timestamp`
- **IPFS Hashes**: Store proof-of-generation documents off-chain
- **Gas Optimization**: Contracts use OpenZeppelin's optimized implementations

## 🆘 Support

For deployment help, see:
- [CONTRACT_DEPLOYMENT_GUIDE.md](../CONTRACT_DEPLOYMENT_GUIDE.md)
- [DEPLOYMENT.md](../DEPLOYMENT.md)
- [QUICKSTART.md](../QUICKSTART.md)
