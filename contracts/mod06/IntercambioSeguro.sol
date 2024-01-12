// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

// Intercambio de ERC721 por una cantidad x de un ERC20 (StableCoin USDC)
// Compra-Venta de un NFT, vendedor (NFT) y comprador (ERC20)
// Se emitirá un evento al cerrarse la compra-venta
// Montamos un contrato que despliega vendedor (owner) y cualquiera puede comprar con el precio establecido

// El ERC20 será un token que desplegamos nosotros y se usará su dirección en el momento de despliegue del contrato de compra-venta

// Tras desplegar el contrato, le daremos el allowance del NFT al contrato para poder trasnferir el NFT más tarde al encontrar un comprador.

contract IntercambioSeguro {
    address public seller;
    uint256 public price; // Cantidad del ERC20 para poder comprar el NFT
    address public erc20TokenAddress; // Dirección del token (por ej USDC)
    address public erc721TokenAddress; // Dirección del contrato del NFT
    uint public erc721TokenId; // Id del NFT dentro del contrato ERC721



    constructor (uint _price, address _erc20TokenAddress, address _erc721TokenAddress, uint _erc721TokenId) {
        seller = msg.sender;
        price = _price;
        erc20TokenAddress = _erc20TokenAddress;
        erc721TokenAddress = _erc721TokenAddress;
        erc721TokenId = _erc721TokenId;
    }

    function executeTrade() public {
        IERC20 erc20Token = IERC20(erc20TokenAddress);
        IERC721 erc721Token = IERC721(erc721TokenAddress);

        bool erc20TransferSuccessful = erc20Token.transferFrom(msg.sender, seller, price);
        require(erc20TransferSuccessful, "Transferencia del ERC20 no satisfactoria. Recuerda que debes de tener fondos suficientes y de hacer el allowance de minimo el precio a este contrato.");

        erc721Token.transferFrom(seller, msg.sender, erc721TokenId);
    }
}