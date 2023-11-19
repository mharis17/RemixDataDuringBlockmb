// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.3/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.7.3/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.7.3/access/Ownable.sol";
import "@openzeppelin/contracts@4.7.3/utils/cryptography/draft-EIP712.sol";

contract LazyNFT is ERC721, ERC721URIStorage, Ownable, EIP712 {
    string private constant SIGNING_DOMAIN = "Voucher-Domain";
    string private constant SIGNATURE_VERSION = "1";

    constructor() ERC721("LazyNFT", "LNFT") EIP712(SIGNING_DOMAIN, SIGNATURE_VERSION) {
    }

    struct LazyNFTVoucher {
        uint256 time;
        uint256 price;
        string uri;
        address creator;
        bytes signature;
    }

    uint256 public CurrenttokenId=0;
     struct Status {
        bool isCancel;
    }


    mapping (address => uint[]) public  walletnfts;
    mapping(bytes => Status) public sigValidation;
    event MintSucess (address minter,uint256 tokenid);
    

    function recover(LazyNFTVoucher calldata voucher) public view returns (address) {
        bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
            keccak256("LazyNFTVoucher(uint256 time ,uint256 price,string uri,address creator)"),
            voucher.price,
            keccak256(bytes(voucher.uri)),
            voucher.creator
            
        )));
        address signer = ECDSA.recover(digest, voucher.signature);
        return signer;
    }

    function safeMint(LazyNFTVoucher calldata voucher)
        public
        payable
    {
           require(
            sigValidation[voucher.signature].isCancel == false,
            "order not active"
        );
        require(voucher.creator==recover(voucher),"you are not creator");
        require(msg.value >= voucher.price, "Not enough ether sent.");
        // _safeMint(voucher.buyer, voucher.tokenId);
        _safeMint(msg.sender, CurrenttokenId);
        _setTokenURI(CurrenttokenId, voucher.uri);
          sigValidation[voucher.signature].isCancel = true;
          CurrenttokenId++;
          walletnfts[msg.sender].push(CurrenttokenId);

          emit MintSucess (msg.sender,CurrenttokenId);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

     function getAllValues(address user) public view returns (uint[] memory) {
        return walletnfts[user];
    }

    
    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }


}