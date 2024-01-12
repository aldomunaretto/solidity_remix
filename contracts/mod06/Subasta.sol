// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Subasta {
    uint public bloquesMinimosParaCierre = 5;
    uint public escalon = 100 wei;

    uint public pujaMinima;

    IERC721 public nftAddress;
    uint public nftId;

    address public vendedor;
    address public mayorPostor;
    uint public mayorPuja;
    uint public bloqueUltimaPuja;

    bool public finalizado = false;

    event PujaFinalizada(address ganador, uint precio);

    constructor(uint _pujaMinima, address _nftAddress, uint _nftId) {
        pujaMinima = _pujaMinima;
        nftAddress = IERC721(_nftAddress);
        nftId = _nftId;
        vendedor = msg.sender;
    }

    function pujar() public payable {
        if (finalizado) revert("Subasta ya finalizada");
        if (msg.value >= mayorPuja+escalon && msg.value >= pujaMinima) {
            payable(mayorPostor).transfer(mayorPuja);

            mayorPostor = msg.sender;
            mayorPuja = msg.value;
            bloqueUltimaPuja = block.number;
        } else {
            revert("Debes mandar mas fondos");
        }
    }

    function finalizar_subasta() public {
        require(mayorPostor != address(0), "No hay pujas");
        require(block.number >= bloqueUltimaPuja+bloquesMinimosParaCierre, "No han pasado 5 bloques desde la ultima puja");

        finalizado = true;
        payable(vendedor).transfer(mayorPuja);
        try nftAddress.transferFrom(vendedor, mayorPostor, nftId) {
            emit PujaFinalizada(mayorPostor, mayorPuja);
        } catch {
            revert("No se ha podido transferir el NFT.");
        }
    }
}