// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// interface IUniswapV2Router02 {
//     function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
//     function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
// }

interface IUniswapV2Factory {
  
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

  function feeTo() external view returns (address);

  function feeToSetter() external view returns (address);

  function getPair(address tokenA, address tokenB) external view returns (address pair);

  function allPairs(uint) external view returns (address pair);

  function allPairsLength() external view returns (uint);

  function createPair(address tokenA, address tokenB) external returns (address pair);

  function setFeeTo(address) external;

  function setFeeToSetter(address) external;   
}
 
interface IUniswapV2Router02 {


    function getAmountsOut(uint amountIn, address[] memory path)
    external
    view
    returns (uint[] memory amounts);

    function swapExactTokensForTokens(
    uint amountIn,
    uint amountOutMin,
    address[] calldata path,
    address to,
    uint deadline
  ) external returns (uint[] memory amounts);

  function swapExactTokensForETH(
    uint amountIn,
    uint amountOutMin,
    address[] calldata path,
    address to,
    uint deadline
  ) external returns (uint[] memory amounts);

  function swapExactETHForTokens(
    uint amountOutMin,
    address[] calldata path,
    address to,
    uint deadline
  ) external payable returns (uint[] memory amounts);

  function addLiquidity(
    address tokenA,
    address tokenB,
    uint amountADesired,
    uint amountBDesired,
    uint amountAMin,
    uint amountBMin,
    address to,
    uint deadline
  )
    external
    returns (
      uint amountA,
      uint amountB,
      uint liquidity
    );


function addLiquidityETH(
  address token,
  uint amountTokenDesired,
  uint amountTokenMin,
  uint amountETHMin,
  address to,
  uint deadline
) external payable returns (uint amountToken, uint amountETH, uint liquidity);


  function removeLiquidity(
    address tokenA,
    address tokenB,
    uint liquidity,
    uint amountAMin,
    uint amountBMin,
    address to,
    uint deadline
  ) external returns (uint amountA, uint amountB);



    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
 
    function factory() external pure returns (address);
 
    function WETH() external pure returns (address);
 
}

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


library SafeMath {
  /**
   * @dev Returns the addition of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `+` operator.
   *
   * Requirements:
   * - Addition cannot overflow.
   */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }


  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, "SafeMath: subtraction overflow");
  }


  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;

    return c;
  }


  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }


  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, "SafeMath: division by zero");
  }


  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, errorMessage);
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }


  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, "SafeMath: modulo by zero");
  }


  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
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



contract TokenSwap  is Context, IERC20, Ownable {
    // address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    // address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    address private constant UNISWAP_V2_ROUTER = 0xddaAd340b0f1Ef65169Ae5E41A8b10776a75482d;
    address private constant WETH = 0xf8e81D47203A594245E36C48e151709F0C19fBe8;
    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;
    string public _name = "Exchange";
    string public _symbol = "EXC";
    uint8 public _decimals = 18;
    uint256 public _totalSupply = 10000 * 10 ** uint256(_decimals);
    // address public owner;
      address  payable taxRecipient;
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;


    // mapping(address => uint256) public balanceOf;
    // mapping(address => mapping(address => uint256)) public allowance;
    // bool private inSwap = false;


    //    modifier lockTheSwap {
    //     inSwap = true;
    //     _;
    //     inSwap = false;
    // }
 

    constructor(address payable _taxRecipient ) {

        // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0xddaAd340b0f1Ef65169Ae5E41A8b10776a75482d);


        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
        // owner = msg.sender;
        _balances[msg.sender] = _totalSupply;
        taxRecipient = _taxRecipient;
        emit Transfer(address(0), msg.sender, _totalSupply);

    }


    function decimals() external override view returns (uint8) {
    return _decimals;
  }


  function symbol() external override view returns (string memory) {
    return _symbol;
  }


  function name() external override view returns (string memory) {
    return _name;
  }

 
  function totalSupply() public override view returns (uint256) {
    return _totalSupply;
  }


  function balanceOf(address account) public override view returns (uint256) {
    return _balances[account];
  }

  function transfer(address recipient, uint256 amount) public override returns (bool) {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }


  function allowance(address owner, address spender) external override view returns (uint256) {
    return _allowances[owner][spender];
  }

  function approve(address spender, uint256 amount) public override returns (bool) {
    _approve(_msgSender(), spender, amount);
    return true;
  }


  function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
    _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, " transfer amount exceeds allowance"));
    _transfer(sender, recipient, amount);
    
    return true;
  }


  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
    return true;
  }


  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, " decreased allowance below zero"));
    return true;
  }


  function burn(uint256 amount) public returns (bool) {
    _burn(_msgSender(), amount);
    return true;
  }


  function _transfer(address sender, address recipient, uint256 amount) internal {
    require(sender != address(0), " transfer from the zero address");
    require(recipient != address(0), " transfer to the zero address");

    // _balances[sender] = _balances[sender].sub(amount, " transfer amount exceeds balance");
    // _balances[recipient] = _balances[recipient].add(amount);
    // emit Transfer(sender, recipient, amount);


         uint256 fee = (amount * 5) / 100;
        uint256 transferAmount = amount - fee;

        _balances[sender] -= amount;
        _balances[recipient] += transferAmount;
        emit Transfer(msg.sender, recipient, transferAmount);

        if (fee > 0) {
            // _balances[owner] += fee;
            // emit Transfer(msg.sender, owner, fee);
            //   _balances[taxRecipient] += fee;
            _balances[address(this)]+=fee;
              swapTokensForEth(fee);
            emit Transfer(msg.sender, taxRecipient, fee);

        }

  }


//   function _mint(address account, uint256 amount) internal {
//     require(account != address(0), " mint to the zero address");

//     _totalSupply = _totalSupply.add(amount);
//     _balances[account] = _balances[account].add(amount);
//     emit Transfer(address(0), account, amount);
//   }


  function _burn(address account, uint256 amount) public {
    require(account != address(0), "burn from the zero address");

    _balances[account] = _balances[account].sub(amount, ": burn amount exceeds balance");
    _totalSupply = _totalSupply.sub(amount);
    emit Transfer(account, address(0), amount);
  }

  function _approve(address owner, address spender, uint256 amount) internal {
    require(owner != address(0), ": approve fromm the zero address");
    require(spender != address(0), ": approvee to the zero address");
    // require(balanceOf(owner)>0,"error");   
    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }


  function _burnFrom(address account, uint256 amount) internal {
    _burn(account, amount);
    _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, ": burn amount exceeds allowance"));
  }

    // function approve(address spender, uint256 amount) public returns (bool) {
    //     allowance[msg.sender][spender] = amount;
    //     emit Approval(msg.sender, spender, amount);
    //     return true;
    // }

    // function transfer(address recipient, uint256 amount) public returns (bool) {
    //     require(recipient != address(0), "Exchange: transfer to the zero address");
    //     require(amount > 0, "Exchange: Transfer amount must be greater than zero");
    //     require(balanceOf[msg.sender] >= amount, "Exchange: Insufficient balance");

    //     uint256 fee = (amount * 5) / 100;
    //     uint256 transferAmount = amount - fee;

    //     balanceOf[msg.sender] -= amount;
    //     balanceOf[recipient] += transferAmount;
    //     emit Transfer(msg.sender, recipient, transferAmount);

    //     // if (fee > 0) {
    //     //     balanceOf[owner] += fee;
    //     //     emit Transfer(msg.sender, owner, fee);
    //         //   balanceOf[taxRecipient] += fee;
    //         //   swapTokensForEth(fee);
    //         // emit Transfer(msg.sender, taxRecipient, fee);

    //     // }


    //     return true;
    // }

    // function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
    //     require(sender != address(0), "Exchange: transfer from the zero address");
    //     require(recipient != address(0), "Exchange: transfer to the zero address");
    //     require(amount > 0, "Exchange: Transfer amount must be greater than zero");
    //     require(balanceOf[sender] >= amount, "Exchange: Insufficient balance");
    //     // require(allowance[sender][msg.sender] >= amount, "Exchange: Allowance exceeded");

    //     uint256 fee = (amount * 5) / 100;
    //     uint256 transferAmount = amount - fee;

    //     balanceOf[sender] -= amount;
    //     balanceOf[recipient] += transferAmount;
    //     emit Transfer(sender, recipient, transferAmount);

    //     // if (fee > 0) {
    //     //     balanceOf[owner] += fee;
    //     //     emit Transfer(sender, owner, fee);
    //         //  balanceOf[taxRecipient] += fee;
    //         // emit Transfer(sender, taxRecipient, fee);
    //     // }

    //     allowance[sender][msg.sender] -= amount;
    //     emit Approval(sender, msg.sender, allowance[sender][msg.sender]);

    //     return true;
    // }


        function swapTokensForEth(uint256 tokenAmount) public  {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        // transferFrom(msg.sender, address(this), tokenAmount);
        // transfer(address(this), tokenAmount);
        _approve(address(this),address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            // address(this),
            taxRecipient,
            block.timestamp
        );
    }

  
  receive() payable external {}


    // event Transfer(address indexed from, address indexed to, uint256 value);
    // event Approval(address indexed owner, address indexed spender, uint256 value);

}




