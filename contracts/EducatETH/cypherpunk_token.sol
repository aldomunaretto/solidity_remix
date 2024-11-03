// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CypherpunkNFT is ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;

    constructor() ERC721("CypherpunkToken", "CypherTK") Ownable(msg.sender) {
    }

    function createNFT(address to) public onlyOwner returns (uint256) {
        uint256 newTokenId = _nextTokenId++;
        _safeMint(to, newTokenId);
        _setTokenURI(newTokenId, "https://gateway.lighthouse.storage/ipfs/bafkreif6f4orrcbcwibs6calnzvo4vz5vy2gbg7fklwwfciuhlydqvvjvy");
        return newTokenId;
    }
}
