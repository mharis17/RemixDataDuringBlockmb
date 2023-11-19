// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.3/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "hardhat/console.sol";

contract Vesting  is Ownable {
    IERC20 public token;
 
    uint256 public expiry;
     mapping(address => bool) public whitelist;
    bool public locked = false;
    bool public claimed = false;

    /////
    uint256 public totalLockedAmount;
    uint256 public startTime;
    uint256 public constant PERCENTAGE_FACTOR = 100;
    uint256[3] public unlockTimes; // Array to store the three unlock times (in seconds from startTime)
    uint256[3] public unlockPercentages; // Array to store the corresponding unlock percentages (0-100)
    mapping(uint256 => uint256) public amountWithdrawn; // Track the amount already withdrawn for each unlock period

    constructor (address _token) {
        token = IERC20(_token);
    }

 modifier onlyWhitelisted() {
        require(whitelist[msg.sender], "You are not whitelisted.");
        _;
    }



   /**
     * @notice Add to whitelist
     */
    function addToWhitelist(address[] calldata toAddAddresses)  external onlyOwner {
        for (uint i = 0; i < toAddAddresses.length; i++) {
            whitelist[toAddAddresses[i]] = true;
        }
    }

    /**
     * @notice Remove from whitelist
     */
    function removeFromWhitelist(address[] calldata toRemoveAddresses)
    external onlyOwner
    {
        for (uint i = 0; i < toRemoveAddresses.length; i++) {
            delete whitelist[toRemoveAddresses[i]];
        }
    }


    // function lock(address _from, uint256[3] memory _unlockTimes, uint256[3] memory _unlockPercentages, uint256 _amount) external {
    function lock( uint256[3] memory _unlockTimes, uint256[3] memory _unlockPercentages, uint256 _amount) external {

        require(!locked, "We have already locked tokens.");
        // token.transferFrom(_from, address(this), _amount);

        require(_unlockTimes.length == 3 && _unlockPercentages.length == 3, "Invalid array lengths.");

        // startTime = _startTime;
        startTime = block.timestamp;
        unlockTimes = _unlockTimes;
        unlockPercentages = _unlockPercentages;

        // // Ensure unlock times are in the future and in increasing order
        // for (uint256 i = 0; i < unlockTimes.length; i++) {
        //     require(unlockTimes[i] > block.timestamp, "Unlock time should be in the future.");
        //     if (i > 0) {
        //         require(unlockTimes[i] > unlockTimes[i - 1], "Unlock times should be in increasing order.");
        //     }
        // }

        // receiver = _receiver;
        totalLockedAmount = _amount;
        // expiry = _expiry;
        locked = true;
    }

  


// ["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4"]
//["1690961112","1690961232","1690961412"]
// ["10","50","60"]
// 100000000000000000000



function withdraw(uint256 _choosenamount) external onlyWhitelisted {
    require(locked, "Funds have not been locked.");
    require(block.timestamp >= startTime, "Withdrawals are not allowed yet.");
    require(_choosenamount > 0, "Withdrawal amount must be greater than zero.");

    uint256 withdrawableAmount = 0;

    for (uint256 i = 0; i < unlockTimes.length; i++) {
        if (block.timestamp >= unlockTimes[i]) {
            uint256 unlockedPercentage = unlockPercentages[i];
            uint256 unlockAmount = (totalLockedAmount * unlockedPercentage) / PERCENTAGE_FACTOR;

            if (amountWithdrawn[i] < unlockAmount) {
                uint256 remainingWithdrawal = unlockAmount - amountWithdrawn[i];
                uint256 toWithdraw = (remainingWithdrawal >= _choosenamount) ? _choosenamount : remainingWithdrawal;
                withdrawableAmount += toWithdraw;
                amountWithdrawn[i] += toWithdraw;
            }
        }
    }

    require(withdrawableAmount > 0, "No tokens available for withdrawal yet.");

    // Update totalLockedAmount to prevent double withdrawal
    totalLockedAmount -= withdrawableAmount;

    token.transfer(msg.sender, withdrawableAmount);
}


    function getTime() external view returns (uint256) {
        return block.timestamp;
    }

    
    function isWhitelisted(address _address) external view returns (bool) {
        return whitelist[_address];
    }

 
}