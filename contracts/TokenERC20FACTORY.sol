// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20.sol"; // Import the ERC-20 contract template

contract TokenFactory {
    address public feeCollectionAddress; // The address that collects the creation fees
    uint256 public burnableCreationFee;// Fee required for creating burnable tokens
    uint256 public mintableCreationFee;// Fee required for creating mintable tokens

    event TokenCreated(address indexed owner, address indexed tokenAddress);

    constructor(address _feeCollectionAddress, uint256 _burnableCreationFee,uint256 _mintableCreationFee ) {
        feeCollectionAddress = _feeCollectionAddress; // launpadpad
        burnableCreationFee=_burnableCreationFee;
        mintableCreationFee=_mintableCreationFee;

    }

    function setFeeCollectionAddress(address _newFeeCollectionAddress) public {
        require(msg.sender == feeCollectionAddress, "Only fee collection address can change this");
        feeCollectionAddress = _newFeeCollectionAddress;
    }

    function setCreationFee(uint256 _burnableCreationFee,uint256 _mintableCreationFee ) public {
        require(msg.sender == feeCollectionAddress, "Only fee collection address can change this");
        burnableCreationFee=_burnableCreationFee;
        mintableCreationFee=_mintableCreationFee;
    }


    function createToken(
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        uint8 decimal,
        bool  isBurnable
       
    ) public payable {
    require(
    (isBurnable && msg.value >= burnableCreationFee) || (!isBurnable && msg.value >= mintableCreationFee),
    "Insufficient fee sent"
);
        address newToken = address(new ERC20 (name, symbol, initialSupply, msg.sender,decimal,isBurnable));
        emit TokenCreated(msg.sender, newToken);
    }


    function withdrawFunds(uint256 amount) public {
    require(msg.sender == feeCollectionAddress, "Only fee collection address can withdraw funds");
    require(address(this).balance >= amount, "Insufficient balance in the contract");
    
    payable(msg.sender).transfer(amount);
}


}