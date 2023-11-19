




  function mint (address account, uint256 amount ) public  {
    require(msg.sender==Contractowner,"you are not the owner");
    _balances[account] += amount;
    emit Transfer(address(0), msg.sender, amount);
  }

  function _mintSupply(address account, uint256 amount) public {
    require(account != address(0), " mint to the zero address");
    require(msg.sender==Contractowner,"you are not the owner");


    _totalSupply = _totalSupply.add(amount);
    _balances[account] = _balances[account].add(amount);
    emit Transfer(address(0), account, amount);
  }

   function burn(uint256 amount) public returns (bool) {
    _burn(_msgSender(), amount);
    return true;
  }

   function _burn(address account, uint256 amount) public {
    require(account != address(0), "burn from the zero address");

    _balances[account] = _balances[account].sub(amount, ": burn amount exceeds balance");
    _totalSupply = _totalSupply.sub(amount);
    emit Transfer(account, address(0), amount);
  }

  function _burnFrom(address account, uint256 amount) internal {
    _burn(account, amount);
    _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, ": burn amount exceeds allowance"));
  }
