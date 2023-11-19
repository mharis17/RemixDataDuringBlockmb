// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;



abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract ZKPoodle is IERC20 , Ownable {

    string public constant name = "ZKPoodle";
    string public constant symbol = "ZKPUP";
    uint8 public constant decimals = 18;
    uint256 private constant MAX_SUPPLY = 100_000_000_000 * (10 ** uint256(decimals));
    uint256 private _totalSupply;

    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    uint256 public marketingTax = 1;
    uint256 public burnTax = 1;
    uint256 public reflectionTax = 1;
    uint256 public developmentTax = 1;
    uint256 public liquidityTax = 1;
    
    mapping (address => uint256) public reflectionBalance;
    mapping (address => uint256) public reflectionTime;
    uint256 public totalReflection;
    
    constructor() {
        
        _totalSupply = MAX_SUPPLY;
        _balances[msg.sender] = _totalSupply;
        _isExcludedFromFee[owner()] = true;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function changeMarketingTax(uint256 _newTax) external onlyOwner{
        marketingTax  = _newTax;
    }

    function changeBurnTax(uint256 _newTax) external onlyOwner{
        burnTax  = _newTax;
    }

    function changeReflectionTax(uint256 _newTax) external onlyOwner{
        reflectionTax  = _newTax;
    }

    function changeDevelopmentTax(uint256 _newTax) external onlyOwner{
        developmentTax  = _newTax;
    }

    function changeLiquidityTax(uint256 _newTax) external onlyOwner{
        liquidityTax  = _newTax;
    }
    
    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }
     function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }
    

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        require(recipient != address(0), "ZKPoodle: transfer to the zero address");
        require(amount > 0, "ZKPoodle: transfer amount must be greater than zero");
        require(amount <= _balances[msg.sender], "ZKPoodle: insufficient balance");

        bool takeFee = true;

         if (_isExcludedFromFee[recipient] || _isExcludedFromFee[msg.sender]) {
            takeFee = false;

            _transfer(recipient,amount);
        } else {

        uint256 marketingAmount = amount * marketingTax / 100;
        uint256 burnAmount = amount * burnTax / 100;
        uint256 reflectionAmount = amount * reflectionTax / 100;
        uint256 developmentAmount = amount * developmentTax / 100;
        uint256 liquidityAmount = amount * liquidityTax / 100;
        uint256 transferAmount = amount - marketingAmount - burnAmount - reflectionAmount - developmentAmount - liquidityAmount;
        
        _balances[msg.sender] -= amount;
        _balances[recipient] += transferAmount;
        
        // Apply taxes
        _balances[address(0)] += burnAmount;
        _balances[address(this)] += marketingAmount + developmentAmount + liquidityAmount;
        reflectionBalance[msg.sender] += reflectionAmount;
        totalReflection += reflectionAmount;

        // Update reflection time
        if (reflectionTime[msg.sender] == 0) {
            reflectionTime[msg.sender] = block.timestamp;
        }
        
        
        emit Transfer(msg.sender, recipient, transferAmount);
        emit Transfer(msg.sender, address(0), burnAmount);
        emit Transfer(msg.sender, address(this), marketingAmount + developmentAmount + liquidityAmount);
        }
        return true;
    }
    

    function _transfer(address recipient, uint256 amount) private returns (bool success) {
    _balances[msg.sender] -= amount;
    _balances[recipient] += amount;
    emit Transfer(msg.sender, recipient, amount); // Emit a transfer event
    return true; // Return a success flag
   }

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }
     

    // function allowance(address owner, address spender)
    function allowance(address owner, address spender) external view override returns (uint256) {
    return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
      _allowances[msg.sender][spender] = amount;
      emit Approval(msg.sender, spender, amount);
    return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
      require(recipient != address(0), "ZKPoodle: transfer to the zero address");
      require(amount > 0, "ZKPoodle: transfer amount must be greater than zero");
      require(amount <= _balances[sender], "ZKPoodle: insufficient balance");
      require(amount <= _allowances[sender][msg.sender], "ZKPoodle: insufficient allowance");

     bool takeFee = true;

      if (_isExcludedFromFee[recipient] || _isExcludedFromFee[sender]) {
            takeFee = false;

         _transferFrom(sender,recipient,amount);
        } else {

      uint256 marketingAmount = amount * marketingTax / 100;
      uint256 burnAmount = amount * burnTax / 100;
      uint256 reflectionAmount = amount * reflectionTax / 100;
      uint256 developmentAmount = amount * developmentTax / 100;
      uint256 liquidityAmount = amount * liquidityTax / 100;
      uint256 transferAmount = amount - marketingAmount - burnAmount - reflectionAmount - developmentAmount - liquidityAmount;
    
    _balances[sender] -= amount;
    _balances[recipient] += transferAmount;
    _allowances[sender][msg.sender] -= amount;

    // Apply taxes
    _balances[address(0)] += burnAmount;
    _balances[address(this)] += marketingAmount + developmentAmount + liquidityAmount;
    reflectionBalance[sender] += reflectionAmount;
    totalReflection += reflectionAmount;

    // Update reflection time
    if (reflectionTime[sender] == 0) {
        reflectionTime[sender] = block.timestamp;
    }
    
    emit Transfer(sender, recipient, transferAmount);
    emit Transfer(sender, address(0), burnAmount);
    emit Transfer(sender, address(this), marketingAmount + developmentAmount + liquidityAmount);
     }

    return true;
  }

  
  function _transferFrom(address sender, address recipient, uint256 amount) private returns (bool) {
    
    _balances[sender] -= amount;
    _balances[recipient] += amount;
    _allowances[sender][msg.sender] -= amount;

    emit Transfer(sender, recipient, amount);
    return true;
  }

    function setReflectionTax(uint256 newReflectionTax) external {
      require(newReflectionTax <= 100, "ZKPoodle: reflection tax cannot exceed 100%");
      reflectionTax = newReflectionTax; 
  }
    

    function claimReflection() external {
      require(reflectionBalance[msg.sender] > 0, "ZKPoodle: no reflection balance to claim");
      require(block.timestamp >= reflectionTime[msg.sender] + 3 days, "ZKPoodle: reflection can only be claimed after 3 days");
 
      uint256 reflectionAmount = reflectionBalance[msg.sender];
      reflectionBalance[msg.sender] = 0;
     _balances[msg.sender] += reflectionAmount;
     totalReflection -= reflectionAmount;
    
     emit Transfer(address(this), msg.sender, reflectionAmount);
     }
}