// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract PrimerContrato {
    uint public total;
    address private immutable creador;

    error OnlyOwner();
    event NumeroIncrementado(uint nuevoTotal);

    constructor(uint _total) {
        total = _total;
        creador = msg.sender;
    } 

    function modify() public returns (uint) {
        if (msg.sender != creador) {
            revert OnlyOwner();
        }
        total += 1;
        emit NumeroIncrementado(total);
        return total;
    }

    function modify2() public returns (uint) {
        total +=2;
        return total;
    }
}
