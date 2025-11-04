// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./SARCToken.sol";
import "./Registry.sol";

/**
 * @title MintingController
 * @dev Controls minting of sARC tokens based on validated energy generation
 * Coordinates with Registry for producer verification
 */
contract MintingController is Ownable {
    SARCToken public sarcToken;
    Registry public registry;

    // Track daily minting per producer
    mapping(address => mapping(uint256 => uint256)) public dailyMinted; // producer => day => amount
    
    event EnergySubmitted(
        address indexed producer,
        uint256 kwhAmount,
        uint256 tokenAmount,
        string ipfsHash,
        uint256 timestamp
    );

    constructor(address _sarcToken, address _registry) Ownable(msg.sender) {
        require(_sarcToken != address(0), "Invalid sARC token address");
        require(_registry != address(0), "Invalid registry address");
        
        sarcToken = SARCToken(_sarcToken);
        registry = Registry(_registry);
    }

    /**
     * @dev Submit energy generation and mint sARC tokens
     * @param producer Address of the producer
     * @param kwhAmount Amount of energy generated in kWh (in wei, so 1 kWh = 1e18)
     * @param ipfsHash IPFS hash of the proof-of-generation document
     */
    function submitEnergy(
        address producer,
        uint256 kwhAmount,
        string memory ipfsHash
    ) external {
        require(producer != address(0), "Invalid producer address");
        require(kwhAmount > 0, "kWh amount must be greater than zero");
        require(bytes(ipfsHash).length > 0, "IPFS hash is required");

        // Verify producer is registered and verified
        require(registry.isProducerVerified(producer), "Producer not verified");

        // Get producer info for daily cap check
        (, , uint256 dailyCapKWh, , ) = registry.getProducer(producer);
        
        // Check daily cap (convert to same units)
        uint256 currentDay = block.timestamp / 1 days;
        uint256 mintedToday = dailyMinted[producer][currentDay];
        
        require(
            mintedToday + kwhAmount <= dailyCapKWh * 1e18,
            "Exceeds daily generation cap"
        );

        // Update daily minted amount
        dailyMinted[producer][currentDay] += kwhAmount;

        // Mint sARC tokens (1 kWh = 1 sARC token)
        sarcToken.mint(producer, kwhAmount, ipfsHash);

        emit EnergySubmitted(producer, kwhAmount, kwhAmount, ipfsHash, block.timestamp);
    }

    /**
     * @dev Get minted amount for a producer on a specific day
     * @param producer Address of the producer
     * @param day Day number (timestamp / 1 days)
     */
    function getDailyMinted(address producer, uint256 day) external view returns (uint256) {
        return dailyMinted[producer][day];
    }

    /**
     * @dev Get minted amount for a producer today
     * @param producer Address of the producer
     */
    function getMintedToday(address producer) external view returns (uint256) {
        uint256 currentDay = block.timestamp / 1 days;
        return dailyMinted[producer][currentDay];
    }

    /**
     * @dev Check remaining daily capacity for a producer
     * @param producer Address of the producer
     */
    function getRemainingDailyCapacity(address producer) external view returns (uint256) {
        if (!registry.isProducerVerified(producer)) {
            return 0;
        }

        (, , uint256 dailyCapKWh, , ) = registry.getProducer(producer);
        uint256 currentDay = block.timestamp / 1 days;
        uint256 mintedToday = dailyMinted[producer][currentDay];
        uint256 dailyCapWei = dailyCapKWh * 1e18;

        if (mintedToday >= dailyCapWei) {
            return 0;
        }

        return dailyCapWei - mintedToday;
    }
}
