  // function withdraw() external onlyWhitelisted {
    //     require(locked, "Funds have not been locked");
    //     require(block.timestamp > expiry, "Tokens have not been unlocked");
    //     require(!claimed, "Tokens have already been claimed");
    //     claimed = true;
    //     token.transfer(msg.sender, amount);
    // }

    // function withdraw() external onlyWhitelisted {
    //     require(locked, "Funds have not been locked.");
    //     require(block.timestamp >= startTime, "Withdrawals are not allowed yet.");

    //     // uint256 elapsedTime = block.timestamp - startTime;
    //     uint256 withdrawableAmount = 0;
    //     // console.log(elapsedTime,"eplased time");
    //     console.log(startTime,"start time");

    //     // Calculate the withdrawable amount based on the unlock percentages
    //     for (uint256 i = 0; i < unlockTimes.length; i++) {
    //         //   console.log(unlockTimes[i],"unlock first time");
    //         // if (elapsedTime >= unlockTimes[i]) {
    //         if (block.timestamp >= unlockTimes[i]) {

    //             console.log(unlockTimes[i],"unlock first time");
    //             uint256 unlockedPercentage = unlockPercentages[i];
    //             uint256 unlockAmount = (totalLockedAmount * unlockedPercentage) / PERCENTAGE_FACTOR;
    //             console.log(unlockAmount,"unlock amount");
    //             withdrawableAmount += unlockAmount;
    //         } else {
    //             break; // No more unlocked periods
    //         }
    //     }

    //     require(withdrawableAmount > 0, "No tokens available for withdrawal yet.");

    //     // Update totalLockedAmount to prevent double withdrawal
    //     totalLockedAmount -= withdrawableAmount;

    //     token.transfer(msg.sender, withdrawableAmount);
    // }



        // function withdraw() external onlyWhitelisted {
    //     require(locked, "Funds have not been locked.");
    //     require(block.timestamp >= startTime, "Withdrawals are not allowed yet.");

    //     uint256 withdrawableAmount = 0;

    //     for (uint256 i = 0; i < unlockTimes.length; i++) {
    //         if (block.timestamp >=  unlockTimes[i]) {
    //             uint256 unlockedPercentage = unlockPercentages[i];
    //             uint256 unlockAmount = (totalLockedAmount * unlockedPercentage) / PERCENTAGE_FACTOR;
    //             console.log (unlockAmount,"unlockAmount");

    //             if(amountWithdrawn[i]<=unlockAmount){
    //             uint256 amountWithdrawnForPeriod = amountWithdrawn[i];
    //             console.log(amountWithdrawnForPeriod,"amountWithdrawnForPeriod");
               
    //             uint256 remainingWithdrawal = unlockAmount - amountWithdrawnForPeriod;
    //             // uint256 remainingWithdrawal = unlockAmount - _choosenamount;
                

    //             console.log(remainingWithdrawal,"remainingWithdrawal");
    //             if (remainingWithdrawal > 0) {
    //             console.log(remainingWithdrawal,"remainingWithdrawal in second if");
                    
    //                 withdrawableAmount += remainingWithdrawal;
    //                 amountWithdrawn[i] += remainingWithdrawal;
    //             }
    //             }
               
    //         }
    //     }

    //     require(withdrawableAmount > 0, "No tokens available for withdrawal yet.");

    //     // Update totalLockedAmount to prevent double withdrawal
    //     totalLockedAmount -= withdrawableAmount;

    //     token.transfer(msg.sender, withdrawableAmount);
    // }