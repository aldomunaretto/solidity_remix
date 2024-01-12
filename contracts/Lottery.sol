// SPDX-License-Identifier: MIT

// Establecemos un precio del boleto. 
// Nosotros nos quedamos una comisión del precio del boleto.
// Guardamos el total del premio y vamos subiendo conforme compran boletos
// Si tenemos tiempo añadimos 1er premio, 2do premio, etc...
// Función para comprar el boleto
// Función para terminar el sorteo
// El dueño del sorteo lo termina cuando quiera
// Podemos hacer 100 bolestos unicamente, si se vende el boleto 100 se termina el sorteo automaticamente
// Podemos permitir que cualquiera termine el sorte, si ha psaso x bloques

pragma solidity ^0.8.20;

import "@chainlink/contracts/src/v0.8/vrf/VRFV2WrapperConsumerBase.sol";
import "@chainlink/contracts/src/v0.8/shared/interfaces/LinkTokenInterface.sol";

contract Lottery is VRFV2WrapperConsumerBase {
    uint public ticket_value;
    uint public fee;
    uint public jackpot;
    address[] public participants;
    address public owner;
    address private linkToken = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;
    address private vrfWrapper = 0x99aFAf084eBA697E584501b8Ed2c0B37Dd136693;


    constructor(uint _ticket_value, uint _fee) VRFV2WrapperConsumerBase(linkToken, vrfWrapper) {
        ticket_value = _ticket_value * 10**18;
        fee = _fee * 10**18;
        owner = msg.sender;
    }

    function buyTicket() public payable {
        require(msg.value == ticket_value, "Must send the exact amount for the ticket value");
        participants.push(msg.sender);
        jackpot += ticket_value - fee;
    }

    function endLottery() public {
        require(msg.sender == owner, "You aren't the owner");
        if(participants.length > 0) {
            uint randomNumber = uint(keccak256(abi.encodePacked(participants.length, block.timestamp)));

            uint winningNumber = randomNumber % participants.length;
            address payable winner = payable(participants[winningNumber]);
            winner.transfer(jackpot);
        }
    }
    
    function fulfillRandomWords(uint256 _requestId, uint256[] memory _randomWords) internal virtual override {
        
    }

    function collectFees() public {
        require(msg.sender == owner, "You aren't the owner");
        uint totalFee = address(this).balance - jackpot;
        payable(msg.sender).transfer(totalFee);
    }   

}