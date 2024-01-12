// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC165 {
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

interface IERC721 is IERC165 {
    function balanceOf(address owner) external view returns (uint balance);

    function ownerOf(uint tokenId) external view returns (address owner);

    /*

    function safeTransferFrom(address from, address to, uint tokenId) external;

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId,
        bytes calldata data
    ) external;

    */

    function transferFrom(address from, address to, uint tokenId) external;

    function approve(address to, uint tokenId) external;

    function getApproved(uint tokenId) external view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) external;

    function isApprovedForAll(
        address owner,
        address operator
    ) external view returns (bool);
}

contract DiplomaKeepCoding is IERC721 {
    string public name = "Diploma Keepcoding Blockchain";
    string public symbol = "DKB";

    mapping(uint => address) public ownerOf;
    mapping(address => uint) public balanceOf;
    mapping(uint => address) public getApproved;
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    mapping(uint => string) public tokenNameOf;

    uint private lastTokenId = 0;

    function transferFrom(address from, address to, uint tokenId) external {
        require(msg.sender == from || getApproved[tokenId] == msg.sender || isApprovedForAll[ownerOf[tokenId]][msg.sender], "Ese NFT no es de tu propiedad ni tienes permiso para transferirlo.");
        require(ownerOf[tokenId] == from, "Ese NFT no es propiedad de la wallet desde la que se quiere transferir.");
        ownerOf[tokenId] = to;
        balanceOf[from]--;
        balanceOf[to]++;
    }

    function mint(address to, string memory tokenName) public {
        balanceOf[to]++;
        ownerOf[lastTokenId] = to;
        tokenNameOf[lastTokenId] = tokenName;
        lastTokenId++;
    }

    function approve(address to, uint tokenId) external {
        require(ownerOf[tokenId] == msg.sender);
        getApproved[tokenId] = to;
    } 

    function setApprovalForAll(address operator, bool _approved) external {
        isApprovedForAll[msg.sender][operator] = _approved;
    }

    function supportsInterface(bytes4 interfaceID) external pure returns (bool) {
        return interfaceID == type(IERC721).interfaceId || interfaceID == type(IERC165).interfaceId;
    }

}