import hre from "hardhat";

/**
 * Main deployment script for SOLR-ARC smart contracts
 * Deploys all contracts in the correct order and sets up permissions
 */
async function main() {
  console.log("Starting SOLR-ARC smart contract deployment...\n");

  // Get the deployer account
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);
  console.log("Account balance:", (await hre.ethers.provider.getBalance(deployer.address)).toString());
  console.log();

  // 1. Deploy sARC Token
  console.log("1. Deploying SARCToken...");
  const SARCToken = await hre.ethers.getContractFactory("SARCToken");
  const sarcToken = await SARCToken.deploy();
  await sarcToken.waitForDeployment();
  const sarcTokenAddress = await sarcToken.getAddress();
  console.log("✓ SARCToken deployed to:", sarcTokenAddress);
  console.log();

  // 2. Deploy Registry
  console.log("2. Deploying Registry...");
  const Registry = await hre.ethers.getContractFactory("Registry");
  const registry = await Registry.deploy();
  await registry.waitForDeployment();
  const registryAddress = await registry.getAddress();
  console.log("✓ Registry deployed to:", registryAddress);
  console.log();

  // 3. Deploy MintingController
  console.log("3. Deploying MintingController...");
  const MintingController = await hre.ethers.getContractFactory("MintingController");
  const mintingController = await MintingController.deploy(sarcTokenAddress, registryAddress);
  await mintingController.waitForDeployment();
  const mintingControllerAddress = await mintingController.getAddress();
  console.log("✓ MintingController deployed to:", mintingControllerAddress);
  console.log();

  // 4. Deploy Treasury (requires a USDC address - use placeholder for testnet)
  console.log("4. Deploying Treasury...");
  // Note: On Arc Testnet, you'll need the actual USDC contract address
  // For now, we'll deploy a mock USDC or use a placeholder
  const usdcAddress = "0x0000000000000000000000000000000000000000"; // Replace with actual USDC address
  console.log("⚠️  Note: Treasury requires USDC token address. Using placeholder for now.");
  console.log("   Update this in the deployment script with the actual USDC address on Arc Testnet.");
  
  const Treasury = await hre.ethers.getContractFactory("Treasury");
  const treasury = await Treasury.deploy(sarcTokenAddress, usdcAddress);
  await treasury.waitForDeployment();
  const treasuryAddress = await treasury.getAddress();
  console.log("✓ Treasury deployed to:", treasuryAddress);
  console.log();

  // 5. Grant MINTER_ROLE to MintingController
  console.log("5. Setting up permissions...");
  const tx = await sarcToken.grantMinterRole(mintingControllerAddress);
  await tx.wait();
  console.log("✓ Granted MINTER_ROLE to MintingController");
  console.log();

  // Print summary
  console.log("=====================================");
  console.log("🎉 Deployment Complete!");
  console.log("=====================================");
  console.log();
  console.log("Contract Addresses:");
  console.log("-------------------");
  console.log("sARC Token:          ", sarcTokenAddress);
  console.log("Registry:            ", registryAddress);
  console.log("Treasury:            ", treasuryAddress);
  console.log("Minting Controller:  ", mintingControllerAddress);
  console.log();
  console.log("Next Steps:");
  console.log("-----------");
  console.log("1. Update src/lib/constants.ts with these addresses");
  console.log("2. Update Treasury deployment with actual USDC token address");
  console.log("3. Register producers in the Registry contract");
  console.log("4. Fund Treasury with USDC for redemptions");
  console.log();
  console.log("To verify contracts on block explorer, run:");
  console.log(`npx hardhat verify --network arcTestnet ${sarcTokenAddress}`);
  console.log(`npx hardhat verify --network arcTestnet ${registryAddress}`);
  console.log(`npx hardhat verify --network arcTestnet ${mintingControllerAddress} ${sarcTokenAddress} ${registryAddress}`);
  console.log(`npx hardhat verify --network arcTestnet ${treasuryAddress} ${sarcTokenAddress} ${usdcAddress}`);
}

// Execute deployment
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
