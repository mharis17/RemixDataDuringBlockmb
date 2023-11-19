// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./vesting.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts@4.7.3/token/ERC20/IERC20.sol";


contract VestingFactory is Ownable {
    address[] public vestingContracts;
    IERC20 public token;


    event VestingContractCreated(address indexed vestingContract);

    function createVestingContract(address tokenAddress, uint256[3] calldata unlockTimes, uint256[3] calldata unlockPercentages,uint256 amount) external onlyOwner {
        
        token = IERC20(tokenAddress);

        Vesting newVestingContract = new Vesting(tokenAddress);


        // Transfer the approved tokens to the new vesting contract using the transferTokens function
   
        token.transferFrom(msg.sender,address(newVestingContract),amount);
        newVestingContract.transferOwnership(msg.sender);
        
        newVestingContract.lock(unlockTimes, unlockPercentages,amount);
        vestingContracts.push(address(newVestingContract));
        emit VestingContractCreated(address(newVestingContract));
    }

    function getVestingContracts() external view returns (address[] memory) {
        return vestingContracts;
    }
}