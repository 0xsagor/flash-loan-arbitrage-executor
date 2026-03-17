// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title FlashLoanSimple
 * @dev Professional implementation of a one-asset Flash Loan using Aave V3.
 */
contract FlashLoanSimple is FlashLoanSimpleReceiverBase {
    address private immutable owner;

    constructor(address _addressProvider) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) {
        owner = msg.sender;
    }

    /**
     * @dev This function is called after your contract has received the flash loaned amount.
     */
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // 1. ARBITRAGE LOGIC GOES HERE
        // Example: Swap 'asset' on Uniswap, then swap back on SushiSwap.
        
        // 2. Ensure we have enough to repay the loan + premium
        uint256 amountToRepay = amount + premium;
        require(IERC20(asset).balanceOf(address(this)) >= amountToRepay, "Not enough funds to repay loan");

        // 3. Approve Aave Pool to pull the repayment
        IERC20(asset).approve(address(POOL), amountToRepay);

        return true;
    }

    function requestFlashLoan(address _token, uint256 _amount) public {
        require(msg.sender == owner, "Only owner can initiate");
        
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(
            receiverAddress,
            asset,
            amount,
            params,
            referralCode
        );
    }

    function withdraw(address _token) external {
        require(msg.sender == owner, "Only owner");
        IERC20 token = IERC20(_token);
        token.transfer(owner, token.balanceOf(address(this)));
    }

    receive() external payable {}
}
