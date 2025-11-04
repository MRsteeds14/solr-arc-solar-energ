// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Treasury
 * @dev Manages USDC redemptions for sARC tokens
 * Exchange rate: 1 sARC = 0.10 USDC
 */
contract Treasury is Ownable {
    IERC20 public sarcToken;
    IERC20 public usdcToken;
    
    // Exchange rate: 10 sARC = 1 USDC (scaled by 100 to avoid decimals)
    uint256 public constant EXCHANGE_RATE_NUMERATOR = 10; // 10%
    uint256 public constant EXCHANGE_RATE_DENOMINATOR = 100;

    event Redeemed(address indexed user, uint256 sarcAmount, uint256 usdcAmount);
    event USDCDeposited(address indexed from, uint256 amount);
    event USDCWithdrawn(address indexed to, uint256 amount);

    constructor(address _sarcToken, address _usdcToken) Ownable(msg.sender) {
        require(_sarcToken != address(0), "Invalid sARC token address");
        require(_usdcToken != address(0), "Invalid USDC token address");
        
        sarcToken = IERC20(_sarcToken);
        usdcToken = IERC20(_usdcToken);
    }

    /**
     * @dev Redeem sARC tokens for USDC
     * @param sarcAmount Amount of sARC tokens to redeem
     */
    function redeem(uint256 sarcAmount) external {
        require(sarcAmount > 0, "Amount must be greater than zero");
        
        // Calculate USDC amount: sarcAmount * 0.10
        uint256 usdcAmount = (sarcAmount * EXCHANGE_RATE_NUMERATOR) / EXCHANGE_RATE_DENOMINATOR;
        
        require(usdcAmount > 0, "USDC amount too small");
        require(usdcToken.balanceOf(address(this)) >= usdcAmount, "Insufficient USDC in treasury");

        // Burn sARC tokens by transferring them to this contract
        require(
            sarcToken.transferFrom(msg.sender, address(this), sarcAmount),
            "sARC transfer failed"
        );

        // Transfer USDC to the user
        require(
            usdcToken.transfer(msg.sender, usdcAmount),
            "USDC transfer failed"
        );

        emit Redeemed(msg.sender, sarcAmount, usdcAmount);
    }

    /**
     * @dev Calculate USDC amount for a given sARC amount
     * @param sarcAmount Amount of sARC tokens
     * @return USDC amount
     */
    function calculateUSDCAmount(uint256 sarcAmount) external pure returns (uint256) {
        return (sarcAmount * EXCHANGE_RATE_NUMERATOR) / EXCHANGE_RATE_DENOMINATOR;
    }

    /**
     * @dev Deposit USDC into the treasury
     * @param amount Amount of USDC to deposit
     */
    function depositUSDC(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        
        require(
            usdcToken.transferFrom(msg.sender, address(this), amount),
            "USDC transfer failed"
        );

        emit USDCDeposited(msg.sender, amount);
    }

    /**
     * @dev Withdraw USDC from the treasury (owner only)
     * @param amount Amount of USDC to withdraw
     */
    function withdrawUSDC(uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than zero");
        require(usdcToken.balanceOf(address(this)) >= amount, "Insufficient USDC balance");

        require(
            usdcToken.transfer(msg.sender, amount),
            "USDC transfer failed"
        );

        emit USDCWithdrawn(msg.sender, amount);
    }

    /**
     * @dev Get treasury USDC balance
     */
    function getUSDCBalance() external view returns (uint256) {
        return usdcToken.balanceOf(address(this));
    }

    /**
     * @dev Get treasury sARC balance
     */
    function getSARCBalance() external view returns (uint256) {
        return sarcToken.balanceOf(address(this));
    }
}
