// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title SARCToken
 * @dev sARC Token - Solar energy tokenization (1 kWh = 1 sARC)
 * Only the MINTER_ROLE (MintingController) can mint new tokens
 */
contract SARCToken is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    event TokensMinted(address indexed to, uint256 amount, string ipfsHash);

    constructor() ERC20("Solar ARC Token", "sARC") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /**
     * @dev Mint sARC tokens representing solar energy generation
     * @param to Address of the producer receiving tokens
     * @param amount Amount of tokens to mint (in wei, 1 token = 1 kWh)
     * @param ipfsHash IPFS hash of the proof-of-generation document
     */
    function mint(address to, uint256 amount, string memory ipfsHash) external onlyRole(MINTER_ROLE) {
        require(to != address(0), "Cannot mint to zero address");
        require(amount > 0, "Amount must be greater than zero");
        
        _mint(to, amount);
        emit TokensMinted(to, amount, ipfsHash);
    }

    /**
     * @dev Grant minting role to the MintingController contract
     * @param minter Address of the minting controller
     */
    function grantMinterRole(address minter) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(MINTER_ROLE, minter);
    }
}
