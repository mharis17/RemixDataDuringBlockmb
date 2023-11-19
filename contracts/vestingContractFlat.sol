// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}
import "./Ownable.sol";

 contract Vesting  is Ownable {
    IERC20 public token;
 
    uint256 public expiry;
    uint256 public totalLockedAmount;
    uint256 public startTime;
    uint256 public constant PERCENTAGE_FACTOR = 100;
    uint256[3] public unlockTimes; // Array to store the three unlock times (in seconds from startTime)
    uint256[3] public unlockPercentages; // Array to store the corresponding unlock percentages (0-100)
    bool public locked = false;
    bool public claimed = false;
    mapping(uint256 => uint256) public amountWithdrawn; // Track the amount already withdrawn for each unlock period
    mapping(address => bool) public whitelist;

    constructor (address _token,address _owner) {

        token = IERC20(_token);
        _transferOwnership(_owner);
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

        startTime = block.timestamp;
        unlockTimes = _unlockTimes;
        unlockPercentages = _unlockPercentages;
        totalLockedAmount = _amount;
        locked = true;
    }

  


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