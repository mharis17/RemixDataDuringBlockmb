// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./simple721A.sol"; // Import the ERC-20 contract template

contract TokenFactory {
    address public feeCollectionAddress; // The address that collects the creation fees
       address[] public deployedNFTs;
       uint256 public CreationFee;
   

    event TokenCreated(address indexed owner, address indexed tokenAddress);

    constructor(address _feeCollectionAddress ) {
        feeCollectionAddress = _feeCollectionAddress; // launpadpad

    }

    function setFeeCollectionAddress(address _newFeeCollectionAddress) public {
        require(msg.sender == feeCollectionAddress, "Only fee collection address can change this");
        feeCollectionAddress = _newFeeCollectionAddress;
    }

    function setCreationFee(uint256 _CreationFee ) public {
        require(msg.sender == feeCollectionAddress, "Only fee collection address can change this");
        CreationFee=_CreationFee;
    }


    function createToken(
       string memory _name,string memory _symbol ,string memory baseUri,uint _maxSupply,uint256 _price,bool _isPaused
       
    ) public payable {
   
        address newToken = address(new MINTTEST(_name, _symbol, baseUri, _maxSupply,_price,_isPaused));
         deployedNFTs.push(newToken);
        emit TokenCreated(msg.sender, newToken);
    }


    function withdrawFunds(uint256 amount) public {
    require(msg.sender == feeCollectionAddress, "Only fee collection address can withdraw funds");
    require(address(this).balance >= amount, "Insufficient balance in the contract");
    
    payable(msg.sender).transfer(amount);
}
}