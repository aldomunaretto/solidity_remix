// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// Establecemos un precio del boleto de loteria
// Nosotros nos quedamos una comisión del precio del boleto
// Guardamos el total del premio y vamos subiendo conforme compran boletos

// Si tenemos tiempo añadimos 1er premio, 2o premio...

// Función para comprar boleto

// Función para terminar el sorteo

// El dueño del sorteo termina cuando quiera
// Podemos hacer 100 boletos únicamente, si se vende el boleto 100 se termina el sorteo automáticamente.
// Podemos permitir que cualquiera termine el sorteo, si ha pasado x bloques.

import "@chainlink/contracts/src/v0.8/vrf/VRFV2WrapperConsumerBase.sol";
import "@chainlink/contracts/src/v0.8/shared/interfaces/LinkTokenInterface.sol";

contract Loteria is VRFV2WrapperConsumerBase {
    uint public precio_boleto;
    uint public comision;
    uint public bote;
    address[] public participantes;

    address public owner;

    address linkToken = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;
    address vrfWrapper = 0x99aFAf084eBA697E584501b8Ed2c0B37Dd136693;

    event RandomNumberRequested(uint requestId);
    event Ganador(uint randomWord, uint winnerIndex, address winnerAddress, uint bote);

    constructor(uint _precio_boleto, uint _comision) VRFV2WrapperConsumerBase(linkToken, vrfWrapper) {
        precio_boleto = _precio_boleto;
        comision = _comision;
        owner = msg.sender;
    }

    function comprar_boleto() public payable {
        require(msg.value == precio_boleto, "Debes mandar exactamente los fondos del precio del boleto");
        participantes.push(msg.sender);
        bote += precio_boleto - comision;
    }

    function terminar_loteria() public {
        require(msg.sender == owner, "No eres el owner");
        if (participantes.length >= 1) {
            uint256 requestId = requestRandomness(10**6, 3, 1);
            emit RandomNumberRequested(requestId);
        }
    }

    function fulfillRandomWords(uint256, uint256[] memory _randomWords) internal override {
        uint numero_aleatorio = _randomWords[0];
        uint numero_ganador = numero_aleatorio % participantes.length;

        address payable ganador = payable(participantes[numero_ganador]);
        ganador.transfer(bote);

        emit Ganador(numero_aleatorio, numero_ganador, ganador, bote);
    }

    function cobrar_comision() public {
        require(msg.sender == owner, "No eres el owner");
        uint comision_total = address(this).balance - bote;
        payable(msg.sender).transfer(comision_total);
    }

}