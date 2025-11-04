// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Registry
 * @dev Manages producer verification and whitelisting
 * Stores producer metadata and verification status
 */
contract Registry is Ownable {
    struct Producer {
        bool isVerified;
        uint256 systemCapacityKW;
        uint256 dailyCapKWh;
        uint256 registrationDate;
        string metadata; // IPFS hash or JSON string
    }

    mapping(address => Producer) public producers;
    address[] public producerAddresses;

    event ProducerRegistered(address indexed producer, uint256 systemCapacityKW, uint256 dailyCapKWh);
    event ProducerVerified(address indexed producer);
    event ProducerRemoved(address indexed producer);

    constructor() Ownable(msg.sender) {}

    /**
     * @dev Register a new solar producer
     * @param producer Address of the producer
     * @param systemCapacityKW Solar system capacity in kilowatts
     * @param dailyCapKWh Daily generation cap in kilowatt-hours
     * @param metadata IPFS hash or metadata JSON
     */
    function registerProducer(
        address producer,
        uint256 systemCapacityKW,
        uint256 dailyCapKWh,
        string memory metadata
    ) external onlyOwner {
        require(producer != address(0), "Invalid producer address");
        require(!producers[producer].isVerified, "Producer already registered");
        require(systemCapacityKW > 0, "System capacity must be greater than zero");
        require(dailyCapKWh > 0, "Daily cap must be greater than zero");

        producers[producer] = Producer({
            isVerified: true,
            systemCapacityKW: systemCapacityKW,
            dailyCapKWh: dailyCapKWh,
            registrationDate: block.timestamp,
            metadata: metadata
        });

        producerAddresses.push(producer);

        emit ProducerRegistered(producer, systemCapacityKW, dailyCapKWh);
        emit ProducerVerified(producer);
    }

    /**
     * @dev Update producer verification status
     * @param producer Address of the producer
     * @param verified New verification status
     */
    function setProducerVerification(address producer, bool verified) external onlyOwner {
        require(producers[producer].registrationDate > 0, "Producer not registered");
        producers[producer].isVerified = verified;
        
        if (verified) {
            emit ProducerVerified(producer);
        }
    }

    /**
     * @dev Check if a producer is verified
     * @param producer Address to check
     * @return bool verification status
     */
    function isProducerVerified(address producer) external view returns (bool) {
        return producers[producer].isVerified;
    }

    /**
     * @dev Get producer information
     * @param producer Address of the producer
     */
    function getProducer(address producer) external view returns (
        bool isVerified,
        uint256 systemCapacityKW,
        uint256 dailyCapKWh,
        uint256 registrationDate,
        string memory metadata
    ) {
        Producer memory p = producers[producer];
        return (p.isVerified, p.systemCapacityKW, p.dailyCapKWh, p.registrationDate, p.metadata);
    }

    /**
     * @dev Get total number of registered producers
     */
    function getProducerCount() external view returns (uint256) {
        return producerAddresses.length;
    }
}
