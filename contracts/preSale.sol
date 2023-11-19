

// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

interface IERC20 {
  /**
   * @dev Returns the amount of tokens in existence.
   */
  function totalSupply() external view returns (uint256);

  /**
   * @dev Returns the token decimals.
   */
  function decimals() external view returns (uint8);

  /**
   * @dev Returns the token symbol.
   */
  function symbol() external view returns (string memory);

  /**
  * @dev Returns the token name.
  */
  function name() external view returns (string memory);

  /**
   
   */
 

  /**
   * @dev Returns the amount of tokens owned by `account`.
   */
  function balanceOf(address account) external view returns (uint256);

  /**
   * @dev Moves `amount` tokens from the caller's account to `recipient`.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transfer(address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Returns the remaining number of tokens that `spender` will be
   * allowed to spend on behalf of `owner` through {transferFrom}. This is
   * zero by default.
   *
   * This value changes when {approve} or {transferFrom} are called.
   */
  function allowance(address _owner, address spender) external view returns (uint256);

  /**
   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
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
  function approve(address spender, uint256 amount) external returns (bool);

  /**
   * @dev Moves `amount` tokens from `sender` to `recipient` using the
   * allowance mechanism. `amount` is then deducted from the caller's
   * allowance.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

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
}


contract Context {
  // Empty internal constructor, to prevent people from mistakenly deploying
  // an instance of this contract, which should be used via inheritance.
  constructor ()  { }

  function _msgSender() internal view returns (address payable) {
    return payable (msg.sender);
  }

  function _msgData() internal view returns (bytes memory) {
    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
    return msg.data;
  }
}





contract Ownable is Context {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev Initializes the contract setting the deployer as the initial owner.
   */
  constructor ()  {
    address msgSender = _msgSender();
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
  }

  /**
   * @dev Returns the address of the current owner.
   */
  function owner() public view returns (address) {
    return _owner;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(_owner == _msgSender(), "Ownable: caller is not the owner");
    _;
  }

  /**
   * @dev Leaves the contract without owner. It will not be possible to call
   * `onlyOwner` functions anymore. Can only be called by the current owner.
   *
   * NOTE: Renouncing ownership will leave the contract without an owner,
   * thereby removing any functionality that is only available to the owner.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  /**
   * @dev Transfers ownership of the contract to a new account (`newOwner`).
   * Can only be called by the current owner.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  /**
   * @dev Transfers ownership of the contract to a new account (`newOwner`).
   */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}




contract ERC20Presale is Ownable {
    IERC20 public token; // The ERC-20 token to be sold
    uint256 public rate;         // Token rate per ether (e.g., 1000 tokens per 1 ether)
    uint256 public startTime;    // Presale start time (Unix timestamp)
    uint256 public endTime;      // Presale end time (Unix timestamp)
    uint256 public totalTokens;  // Total tokens available for sale
    uint256 public tokensSold;   // Total tokens sold
    uint256  public PreSaleFee;
    address payable   feeCollector;


    mapping(address => uint256) public contributions;

    event TokensPurchased(address indexed buyer, uint256 amount, uint256 cost);

    constructor(
        address _token, 
        uint256 _rate,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _totalTokens,
        uint256 _PreSaleFee,
        address payable  _feeCollector

    ) payable {
        token = IERC20(_token);
        rate = _rate;
        startTime = _startTime;
        endTime = _endTime;
        totalTokens = _totalTokens;
        PreSaleFee=_PreSaleFee;
        feeCollector=_feeCollector;
        _feeCollector.transfer(msg.value);
    }

    modifier isPresaleOpen() {
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Presale is not open");
        _;
    }

    function buyTokens(uint256 etherAmount) external payable isPresaleOpen {
        require(etherAmount > 0, "Ether amount must be greater than zero");

        uint256 tokenAmount = etherAmount * rate;
        require(tokenAmount <= getRemainingTokens(), "Not enough tokens left for sale");

        require(token.transfer(msg.sender, tokenAmount), "Token transfer failed");
        contributions[msg.sender] += etherAmount;
        tokensSold += tokenAmount;

        emit TokensPurchased(msg.sender, tokenAmount, etherAmount);
    }

    function getRemainingTokens() public view returns (uint256) {
        return totalTokens - tokensSold;
    }

    function withdrawFunds() external onlyOwner {
        address payable ownerPayable = payable(owner());
        ownerPayable.transfer(address(this).balance);
    }

    function withdrawUnsoldTokens() external onlyOwner {
        uint256 unsoldTokens = getRemainingTokens();
        if (unsoldTokens > 0) {
            require(token.transfer(owner(), unsoldTokens), "Token transfer failed");
        }
    }

    // receive() external payable {
    //     buyTokens(msg.value);
    // }
}