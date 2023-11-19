// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.0;

// interface IUniswapV2Router {
//     function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
// }

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

   function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);

}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract CustomToken {
    string public name = "Custom Token";
    string public symbol = "CT";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1000 * 10 ** uint256(decimals);
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    uint256 public feePercentage = 5;

    IUniswapV2Router02 public uniswapRouter;
    address[] public uniswapPath;

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor() {
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
        uniswapRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapPath = [address(this), address(uniswapRouter.WETH()), address(0x000000000000000000000000000000000000dEaD)]; // Replace the last address with the desired token address
    }

  function _approve(address owner, address spender, uint256 amount) internal {
    require(owner != address(0), "ERC20: approve from the zero address");
    require(spender != address(0), "ERC20: approve to the zero address");

    allowance[owner][spender] = amount;
    emit Approval(owner, spender, amount);
}

    function transfer(address to, uint256 value) external returns (bool) {
        require(to != address(0), "Invalid address");
        require(value > 0, "Invalid value");
        require(balanceOf[msg.sender] >= value, "Insufficient balance");

        uint256 fee = (value * feePercentage) / 100;
        uint256 transferAmount = value - fee;

        balanceOf[msg.sender] -= value;
        balanceOf[to] += transferAmount;
        emit Transfer(msg.sender, to, transferAmount);

        if (fee > 0) {
            balanceOf[owner] += fee;
            emit Transfer(msg.sender, owner, fee);
        }

        return true;
    }

    function swapTokens() external {
        uint256 tokenBalance = balanceOf[msg.sender];
        require(tokenBalance > 0, "Insufficient balance");

        uint256 fee = (tokenBalance * feePercentage) / 100;
        uint256 amountToSwap = tokenBalance - fee;

        require(uniswapPath.length >= 2, "Invalid uniswap path");

        // Transfer tokens to the contract
        balanceOf[msg.sender] -= tokenBalance;
        balanceOf[address(this)] += tokenBalance;

        // Perform the swap
        approve(address(uniswapRouter), amountToSwap);
        uniswapRouter.swapExactTokensForTokens(amountToSwap, 0, uniswapPath, msg.sender, block.timestamp);

        if (fee > 0) {
            balanceOf[owner] += fee;
            emit Transfer(address(this), owner, fee);
        }
    }
}
