// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// interface IUniswapV2Router02 {
//     function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
//     function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
// }

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}
 
interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
 
    function factory() external pure returns (address);
 
    function WETH() external pure returns (address);
 
    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}


contract TokenSwap {
    address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;
    string public name = "Exchange";
    string public symbol = "EXC";
    uint8 public decimals = 18;
    uint256 public totalSupply = 10000 * 10 ** uint256(decimals);
    address public owner;
      address public taxRecipient;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    bool private inSwap = false;

       modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }
 

    constructor(address _taxRecipient ) {

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
        taxRecipient = _taxRecipient;
     emit Transfer(address(0), msg.sender, totalSupply);

    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(recipient != address(0), "Exchange: transfer to the zero address");
        require(amount > 0, "Exchange: Transfer amount must be greater than zero");
        require(balanceOf[msg.sender] >= amount, "Exchange: Insufficient balance");

        uint256 fee = (amount * 5) / 100;
        uint256 transferAmount = amount - fee;

        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += transferAmount;
        emit Transfer(msg.sender, recipient, transferAmount);

        // if (fee > 0) {
        //     balanceOf[owner] += fee;
        //     emit Transfer(msg.sender, owner, fee);
            //   balanceOf[taxRecipient] += fee;
            //   swapTokensForEth(fee);
            // emit Transfer(msg.sender, taxRecipient, fee);

        // }

        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        require(sender != address(0), "Exchange: transfer from the zero address");
        require(recipient != address(0), "Exchange: transfer to the zero address");
        require(amount > 0, "Exchange: Transfer amount must be greater than zero");
        require(balanceOf[sender] >= amount, "Exchange: Insufficient balance");
        require(allowance[sender][msg.sender] >= amount, "Exchange: Allowance exceeded");

        uint256 fee = (amount * 5) / 100;
        uint256 transferAmount = amount - fee;

        balanceOf[sender] -= amount;
        balanceOf[recipient] += transferAmount;
        emit Transfer(sender, recipient, transferAmount);

        // if (fee > 0) {
        //     balanceOf[owner] += fee;
        //     emit Transfer(sender, owner, fee);
            //  balanceOf[taxRecipient] += fee;
            // emit Transfer(sender, taxRecipient, fee);
        // }

        allowance[sender][msg.sender] -= amount;
        emit Approval(sender, msg.sender, allowance[sender][msg.sender]);

        return true;
    }


        function swapTokensForEth(uint256 tokenAmount) public  {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        transferFrom(msg.sender, address(this), tokenAmount);
        approve(address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    // function swap(address _tokenIn, address _tokenOut, uint256 _amountIn, uint256 _amountOutMin, address _to) external {
    //     require(_amountIn > 0, "Exchange: Amount in must be greater than zero");

    //     IERC20(_tokenIn).transferFrom(msg.sender, address(this), _amountIn);
    //     IERC20(_tokenIn).approve(UNISWAP_V2_ROUTER, _amountIn);

    //     address[] memory path;
    //     if (_tokenIn == WETH || _tokenOut == WETH) {
    //         path = new address[](2);
    //         path[0] = _tokenIn;
    //         path[1] = _tokenOut;
    //     } else {
    //         path = new address[](3);
    //         path[0] = _tokenIn;
    //         path[1] = WETH;
    //         path[2] = _tokenOut;
    //     }

    //     IUniswapV2Router02(UNISWAP_V2_ROUTER).swapExactTokensForTokens(_amountIn, _amountOutMin, path, _to, block.timestamp);
    //        // Calculate the tax amount (5%)
    //     uint256 taxAmount = (_amountIn * 5) / 100;

    //     // Send the tax to the tax recipient
    //     IERC20(_tokenIn).transfer(taxRecipient, taxAmount);
    // }

    // function getAmountOutMin(address _tokenIn, address _tokenOut, uint256 _amountIn) external view returns (uint256) {
    //     address[] memory path;
    //     if (_tokenIn == WETH || _tokenOut == WETH) {
    //         path = new address[](2);
    //         path[0] = _tokenIn;
    //         path[1] = _tokenOut;
    //     } else {
    //         path = new address[](3);
    //         path[0] = _tokenIn;
    //         path[1] = WETH;
    //         path[2] = _tokenOut;
    //     }

    //     uint256[] memory amountOutMins = IUniswapV2Router02(UNISWAP_V2_ROUTER).getAmountsOut(_amountIn, path);
    //     return amountOutMins[path.length - 1];
    // }



    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
