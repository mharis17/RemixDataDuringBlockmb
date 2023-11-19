// pragma solidity ^0.8.0;

// interface IERC20 {
//     function totalSupply() external view returns (uint256);
//     function balanceOf(address account) external view returns (uint256);
//     function transfer(address recipient, uint256 amount) external returns (bool);
//     function allowance(address owner, address spender) external view returns (uint256);
//     function approve(address spender, uint256 amount) external returns (bool);
//     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    
//     event Transfer(address indexed from, address indexed to, uint256 value);
//     event Approval(address indexed owner, address indexed spender, uint256 value);
// }

// contract ERC20Token is IERC20 {
//     string public name;
//     string public symbol;
//     uint8 public decimals;
//     uint256 private _totalSupply;
//     mapping(address => uint256) private _balances;
//     mapping(address => mapping(address => uint256)) private _allowances;
    
//     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 initialSupply) {
//         name = _name;
//         symbol = _symbol;
//         decimals = _decimals;
//         _totalSupply = initialSupply * 10 ** uint256(_decimals);
//         _balances[msg.sender] = _totalSupply;
//         emit Transfer(address(0), msg.sender, _totalSupply);
//     }
    
//     function totalSupply() public view override returns (uint256) {
//         return _totalSupply;
//     }

//     function balanceOf(address account) public view override returns (uint256) {
//         return _balances[account];
//     }

//     function transfer(address recipient, uint256 amount) public override returns (bool) {
//         _transfer(msg.sender, recipient, amount);
//         return true;
//     }

//     function allowance(address owner, address spender) public view override returns (uint256) {
//         return _allowances[owner][spender];
//     }

//     function approve(address spender, uint256 amount) public override returns (bool) {
//         _approve(msg.sender, spender, amount);
//         return true;
//     }

//     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
//         _transfer(sender, recipient, amount);
//         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
//         return true;
//     }

//     function _transfer(address sender, address recipient, uint256 amount) internal {
//         require(sender != address(0), "ERC20: Transfer from the zero address");
//         require(recipient != address(0), "ERC20: Transfer to the zero address");
//         require(_balances[sender] >= amount, "ERC20: Insufficient balance");

//         _balances[sender] -= amount;
//         _balances[recipient] += amount;

//         emit Transfer(sender, recipient, amount);
//     }

//     function _approve(address owner, address spender, uint256 amount) internal {
//         require(owner != address(0), "ERC20: Approve from the zero address");
//         require(spender != address(0), "ERC20: Approve to the zero address");

//         _allowances[owner][spender] = amount;
//         emit Approval(owner, spender, amount);
//     }
// }


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, ERC20Burnable, Ownable {
    constructor(address initialOwner)
        ERC20("MyToken", "MTK") 
    {
        _mint(msg.sender, 10000 * 10 ** decimals());
         _transferOwnership(initialOwner);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}