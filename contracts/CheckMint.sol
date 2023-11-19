// CHECK IT OUT 


 
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract TheRapWolves is ERC721, Ownable {
    using Strings for uint256;

    // Token name and symbol
    string private _name = "TheRapWolves";
    string private _symbol = "WOOL";

    // Total supply of NFTs
    uint256 public constant totalSupply = 8644;

    // 244 mints to the community wallet
    uint256 public constant communityWallet = 244;

    // Royalty fee percentage
    uint256 public constant royaltyPercentage = 6;

    // NFT price tiers
    uint256[] public mintPrices = [
        0, // First 200 NFTs are free
        11000000000000000, // 0.011 ETH for the next 400
        22000000000000000, // 0.022 ETH for the next 400 NFTs
        32000000000000000, // 0.032 ETH for the next 1,600 NFTs
        72000000000000000, // 0.072 ETH for the next 1,000 NFTs
        88000000000000000, // 0.088 ETH for the next 1,400 NFTs
        220000000000000000, // 0.22 ETH for the next 1,000 NFTs
        380000000000000000, // 0.38 ETH for the next 1,000 NFTs
        800000000000000000, // 0.8 ETH for the next 600 NFTs
        880000000000000000 // 0.88 ETH for the rest of the collection i.e., 800 NFTs
    ];

    uint256 public mintedCount = 0;
    uint256 public communityTokensCount = 0;

    // Wallet address to receive royalties
    address public royaltiesReceiver;
    address public communityTokenReceiver;

    struct NFTMetadata {
        string name;
        string imageURI; // IPFS URL to the generated image
    }

    mapping(uint256 => NFTMetadata) public nftMetadata;

    constructor(
        address _royaltiesReceiver,
        address _communityTokenReceiver
    ) ERC721(_name, _symbol) {
        royaltiesReceiver = _royaltiesReceiver;
        communityTokenReceiver = _communityTokenReceiver;
    }

 
function mintMultipleNFTs(uint256 _numberOfNFTs, string memory _imageURI) external payable {
        require(_numberOfNFTs > 0, "Invalid number of NFTs");
        require(_numberOfNFTs <= 10, "Not more than 10 NFTs");
        require(mintedCount + _numberOfNFTs <= totalSupply - communityWallet, "Exceeds maximum supply");
        uint256 totalPrice = calculateTotalPrice(_numberOfNFTs);
        require(msg.value >= totalPrice, "Insufficient funds to mint");

        if (msg.value >= totalPrice) {
            payable(msg.sender).transfer(msg.value - totalPrice);
        }

        for (uint256 i = 0; i < _numberOfNFTs; i++) {
            uint256 tokenId = mintedCount;
            _mint(msg.sender, tokenId);
            mintedCount++;

            // Generate and store metadata
            nftMetadata[tokenId] = NFTMetadata({
                name: string(abi.encodePacked("NFT #", tokenId.toString())),
                imageURI: string(abi.encodePacked(_imageURI, tokenId.toString()))
            });
        }

        // Send royalty fee
        uint256 royaltyAmount = (totalPrice * royaltyPercentage) / 100;
        payable(royaltiesReceiver).transfer(royaltyAmount);
    }

 
function calculateTotalPrice(uint256 _numberOfNFTs) internal view returns (uint256) {
        // Calculate the total price for minting _numberOfNFTs
        uint256 totalPrice = 0;
        uint256 tempCount = mintedCount;
        
        for (uint256 i = 0; i < _numberOfNFTs; i++) {
            if(tempCount < 200)
            {
                totalPrice += mintPrices[0];
            }
            else if(tempCount < 600)
            {
                totalPrice += mintPrices[1];
            }
            else if(tempCount < 1000)
            {
                totalPrice += mintPrices[2];
            }
            else if(tempCount < 2600)
            {
                totalPrice += mintPrices[3];
            }
            else if(tempCount < 3600)
            {
                totalPrice += mintPrices[4];
            }
            else if(tempCount < 5000)
            {
                totalPrice += mintPrices[5];
            }
            else if(tempCount < 6000)
            {
                totalPrice += mintPrices[6];
            }
            else if(tempCount < 7000)
            {
                totalPrice += mintPrices[7];
            }
            else if(tempCount < 7600)
            {
                totalPrice += mintPrices[8];
            }
            else if(tempCount < 8400)
            {
                totalPrice += mintPrices[9];
            }
            tempCount++;
        }
        return totalPrice;
    }

 
function sendCommunityTokens() external payable onlyOwner {
        require(communityTokensCount == 0, "Community Tokens already sent");
        require(mintedCount >= 2352, "Minted NFTs are less than 28%");

        for (uint256 i = 0; i < communityWallet; i++) {
            uint256 tokenId = totalSupply - communityWallet + i;
            _mint(communityTokenReceiver, tokenId);
            communityTokensCount++;
        }
    }

    function setRoyaltiesReceiver(address _newReceiver) external onlyOwner {
        royaltiesReceiver = _newReceiver;
    }

    function setCommunityTokenReceiver(address _newReceiver) external onlyOwner {
        communityTokenReceiver = _newReceiver;
    }

    function withdrawRemainingBalance() external onlyOwner {
        require(mintedCount + communityTokensCount == totalSupply, "Minting is not yet complete");
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No balance to withdraw");

        // Transfer the contract's balance to the owner
        payable(owner()).transfer(contractBalance);
    }

}

 
// Wallet to use for mint sales: 0x61902cbAB185644f353400996C8970964B56c31a

// And then for the 244 NFT bundle and sale royalties will be to:  0x8374490ADeDe55a8A35aa2578143695F1F25aFC2

 