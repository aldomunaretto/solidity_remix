// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Auction {
    uint public minimumBlocksToClose = 5;
    uint public deltaOnBid = 100 wei;
    uint public minimumBid;
    IERC721 public nftAddress;
    uint public nftId;
    address public seller;
    address public highestBidder;
    uint public highestBid;
    uint public lastBidBlock;
    bool public auctionEnded = false;

    constructor(uint _minimumBid, address _nftAddress, uint _nftId) {
        minimumBid = _minimumBid;
        nftAddress = IERC721(_nftAddress);
        nftId = _nftId;
        seller = msg.sender;
    }

    event AuctionEnded(address winner, uint winningBid);

    function bid() public payable {
        if (auctionEnded) revert("Auction already ended");
        if (msg.value >= highestBid+deltaOnBid && msg.value >= minimumBid) {
            payable(highestBidder).transfer(highestBid);
            highestBidder = msg.sender;
            highestBid = msg.value;
            lastBidBlock = block.number;
        } else {
            revert("Your bid needs to be higher");
        }
    }

    function auctionEnds() public {
        // if (highestBidder == address(0)) revert("There's no bids");
        // if (block.number >= lastBidBlock+minimumBlocksToClose) revert("You have to wait at least 5 blocks to end the auction");
        require(highestBidder != address(0), "There's no bids");
        require(block.number >= lastBidBlock+minimumBlocksToClose, "You have to wait at least 5 blocks to end the auction");
        auctionEnded = true;
        payable(seller).transfer(highestBid);
        try nftAddress.transferFrom(seller, highestBidder, nftId) {
            emit AuctionEnded(highestBidder, highestBid);
        } catch {
            revert("The NFT couldn't be transfered.");
        }
    }

}