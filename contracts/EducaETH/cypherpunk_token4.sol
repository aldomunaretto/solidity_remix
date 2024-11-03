// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CypherpunkNFTV4 is ERC721URIStorage, Ownable {
    uint256 public tokenCounter;

    constructor(address initialOwner) ERC721("CypherpunkTokenV4", "CypherT3") Ownable(initialOwner) {
        tokenCounter = 0;
    }

    function createNFT() public onlyOwner returns (uint256) {
        uint256 newTokenId = tokenCounter;
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, "https://gateway.lighthouse.storage/ipfs/bafkreif6f4orrcbcwibs6calnzvo4vz5vy2gbg7fklwwfciuhlydqvvjvy");
        tokenCounter += 1;
        return newTokenId;
    }
}