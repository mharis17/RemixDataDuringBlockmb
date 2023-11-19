// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IERC20USDT {
  function totalSupply() external view returns (uint256);

  function decimals() external view returns (uint8);

  function symbol() external view returns (string memory);

  function name() external view returns (string memory);

  function getOwner() external view returns (address);

  function balanceOf(address account) external view returns (uint256);

  function transfer(address recipient, uint256 amount) external returns (bool);

  function allowance(address _owner, address spender) external view returns (uint256);

  function approve(address spender, uint256 amount) external returns (bool);

  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);

  event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract SmartX {
    address public USDT_ADDRESS;
    address private walletAddress;
    constructor() {
        USDT_ADDRESS = 0x55d398326f99059fF775485246999027B3197955; 
        walletAddress = 0x556499eda344C4E27c793f7249339f3FAf12Bc2C;
    }

    event placementDetaill (address walletAddress,address direct,address payment,uint256 amount1,uint256 amount2,uint256 amount3 );
    event upgradeDetaill (address walletAddress,address direct,address payment,uint256 amount1,uint256 amount2,uint256 amount3 );

   
    function placement (address _direct ,address _placement , uint256 amount) external {
        IERC20USDT usdtToken = IERC20USDT(USDT_ADDRESS);
        require (usdtToken.allowance(msg.sender, address(this))== amount,"Approve fund should be equal to package price");
        usdtToken.transferFrom(msg.sender, address(this), amount);

        
        uint256 fourtyfive = fourtyFivePersontage(amount);
        uint256 ten = tenPersontage(amount);

         usdtToken.transfer(_placement, fourtyfive);
         usdtToken.transfer(_direct, fourtyfive);
         usdtToken.transfer(walletAddress, ten); 
         emit placementDetaill (walletAddress,_direct,_placement,fourtyfive,fourtyfive,ten) ;

    }

    function upgrades (address _direct ,address _placement , uint256 amount) external {
        IERC20USDT usdtToken = IERC20USDT(USDT_ADDRESS);
        require (usdtToken.allowance(msg.sender, address(this))    == amount,"Approve funds should be equal to Upgrade value's");
        usdtToken.transferFrom(msg.sender, address(this), amount);

        uint256 seventy = seventyPersontage(amount);
        uint256 twenty = twentyPersontage(amount);
        uint256 d = tenPersontage(amount);

        usdtToken.transfer(_placement, seventy);
        usdtToken.transfer(_direct, twenty);
        usdtToken.transfer(walletAddress, ten);      
        emit upgradeDetaill (walletAddress,_direct,_placement,seventy,twenty,ten) ;

    }    

    function fourtyFivePersontage(uint256 _amount) internal pure returns(uint256){
     return  (_amount / 10000) * 4500; //100 = 1% 
    } 

    function tenPersontage(uint256 _amount) internal pure returns(uint256){
     return (_amount / 10000) * 1000;  
    }
   
    function seventyPersontage(uint256 _amount) internal pure returns(uint256){
     return  (_amount / 10000) * 7000;  
    } 
     
    function twentyPersontage(uint256 _amount) internal pure returns(uint256){
     return  (_amount / 10000) * 2000;
ﾠﾠﾠﾠ}ﾠﾠﾠ
}