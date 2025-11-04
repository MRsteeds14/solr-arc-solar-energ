import hre from "hardhat";

/**
 * Script to register a solar producer in the Registry
 * This should be run after deployment
 */
async function main() {
  // Configuration
  const REGISTRY_ADDRESS = "0x742d35Cc6634C0532925a3b844Bc454e4438f44e"; // Update with your deployed address
  const PRODUCER_ADDRESS = "0x9e7D0d9775d9bacE19B97C8d25C6e572DdbaC072"; // Thirdweb Arc Testnet wallet
  const SYSTEM_CAPACITY_KW = 10; // 10 kW system
  const DAILY_CAP_KWH = 100; // 100 kWh daily cap
  const METADATA = JSON.stringify({
    name: "Demo Solar Producer",
    location: "Demo Location",
    installationDate: "2024-01-01",
  });

  console.log("Registering solar producer...\n");

  // Get the deployer account
  const [deployer] = await hre.ethers.getSigners();
  console.log("Using account:", deployer.address);

  // Get Registry contract
  const Registry = await hre.ethers.getContractFactory("Registry");
  const registry = Registry.attach(REGISTRY_ADDRESS);

  // Register the producer
  console.log("Registering producer:", PRODUCER_ADDRESS);
  console.log("System Capacity:", SYSTEM_CAPACITY_KW, "kW");
  console.log("Daily Cap:", DAILY_CAP_KWH, "kWh");
  console.log();

  const tx = await registry.registerProducer(
    PRODUCER_ADDRESS,
    SYSTEM_CAPACITY_KW,
    DAILY_CAP_KWH,
    METADATA
  );

  console.log("Transaction sent:", tx.hash);
  await tx.wait();
  console.log("✓ Producer registered successfully!");
  console.log();

  // Verify registration
  const isVerified = await registry.isProducerVerified(PRODUCER_ADDRESS);
  const producerInfo = await registry.getProducer(PRODUCER_ADDRESS);
  
  console.log("Verification Status:", isVerified);
  console.log("Producer Info:", {
    isVerified: producerInfo[0],
    systemCapacityKW: producerInfo[1].toString(),
    dailyCapKWh: producerInfo[2].toString(),
    registrationDate: new Date(Number(producerInfo[3]) * 1000).toISOString(),
    metadata: producerInfo[4],
  });
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
