
// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "hardhat/console.sol";


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "./interfaces/Uniswap.sol";
interface IUniswapV2Router {
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
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

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

contract TestUniswapLiquidity {
  // address private constant FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
  // address private constant ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
  // address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

 address private constant FACTORY = 0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8;
  address private constant ROUTER = 0xe2899bddFD890e320e643044c6b95B9B0b84157A;
  address private constant WETH = 0xf8e81D47203A594245E36C48e151709F0C19fBe8;
  event Log(string message, uint val);
event result(uint256 _amounta,uint256 amountB, uint256 liquidity);



  function addLiquidity(
    address _tokenA,
    address _tokenB,
    uint _amountA,
    uint _amountB
  ) external {
    IERC20(_tokenA).transferFrom(msg.sender, address(this), _amountA);
    IERC20(_tokenB).transferFrom(msg.sender, address(this), _amountB);

    IERC20(_tokenA).approve(ROUTER, _amountA);
    IERC20(_tokenB).approve(ROUTER, _amountB);

    (uint amountA, uint amountB, uint liquidity) =
      IUniswapV2Router(ROUTER).addLiquidity(
        _tokenA,
        _tokenB,
        _amountA,
        _amountB,
        1,
        1,
        address(this),
        block.timestamp
      );

    // emit Log("amountA", amountA);
    // emit Log("amountB", amountB);
    // emit Log("liquidity", liquidity);
emit result(amountA,amountB,liquidity);

  }



    function addLiquidityETH(
    address token,
    uint amountTokenDesired
 
    ) external payable   {
    IERC20(token).transferFrom(msg.sender, address(this), amountTokenDesired);
    IERC20(token).approve(ROUTER, amountTokenDesired);
    console.log(msg.value,"wallet eth ");

    (uint amountToken, uint amountETH, uint liquidity)=IUniswapV2Router(ROUTER).addLiquidityETH{value: msg.value }(
    token,
    amountTokenDesired,
      1000,
      1000,
      address(this),
      1692268645
    );
   // console.log(amountToken,amountETH,liquidity);
    emit Log("amountA", amountToken);
    emit Log("amountB", amountETH);
    emit Log("liquidity", liquidity);
    // emit result(amountToken,amountETH,liquidity);
    }



    function swapTokensForEth(uint256 tokenAmount,address token) external {
        address[] memory path = new address[](2);
        path[0] =token ;
        path[1] = WETH;
       IERC20(token).transferFrom(msg.sender, address(this), tokenAmount);
        IERC20(token).approve(address(ROUTER), tokenAmount);
        IUniswapV2Router(ROUTER).swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

  function removeLiquidity(address _tokenA, address _tokenB) external {
    address pair = IUniswapV2Factory(FACTORY).getPair(_tokenA, _tokenB);

    uint liquidity = IERC20(pair).balanceOf(address(this));
    IERC20(pair).approve(ROUTER, liquidity);

    (uint amountA, uint amountB) =
      IUniswapV2Router(ROUTER).removeLiquidity(
        _tokenA,
        _tokenB,
        liquidity,
        1,
        1,
        address(this),
        block.timestamp
      );

    emit Log("amountA", amountA);
    emit Log("amountB", amountB);
  }

  //  function manualswap() external {
  //       require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
  //       uint256 contractBalance = balanceOf(address(this));
  //       swapTokensForEth(contractBalance);
  //   }

  receive() payable external {}
}