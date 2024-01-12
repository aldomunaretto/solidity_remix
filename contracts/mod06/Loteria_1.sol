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

contract Loteria {
    uint public precio_boleto;
    uint public comision;
    uint public bote;
    address[] public participantes;

    address public owner;

    constructor(uint _precio_boleto, uint _comision) {
        precio_boleto = _precio_boleto * 10**18;
        comision = _comision * 10**18;
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
            uint numero_aleatorio = uint(keccak256(abi.encodePacked(participantes.length, block.timestamp)));
            uint numero_ganador = numero_aleatorio % participantes.length;

            address payable ganador = payable(participantes[numero_ganador]);
            ganador.transfer(bote);
        }
    }

    function cobrar_comision() public {
        require(msg.sender == owner, "No eres el owner");
        uint comision_total = address(this).balance - bote;
        payable(msg.sender).transfer(comision_total);
    }

}