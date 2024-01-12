// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract VerifySignature is ERC20 {

    constructor() ERC20("Token seguro", "TKS") {
        _mint(msg.sender, 100);
    }

    function verifySignature(address _signer, string memory _message, bytes memory _signature) internal pure returns (bool) {
        bytes32 hashedMessage = toEthSignedMessageHash(bytes(_message));
        address firmanteOrignal = ECDSA.recover(hashedMessage, _signature);

        return (_signer == firmanteOrignal);
    }

    function toEthSignedMessageHash(bytes memory message) internal pure returns (bytes32) {
        return
            keccak256(bytes.concat("\x19Ethereum Signed Message:\n", bytes(Strings.toString(message.length)), message));
    }

    function transferWithSignature(address from, address to, uint amount, bytes memory signature) public {
        string memory message = "Autorizo a retirar fondos sin mi supervision";

        bool firmaValidada = verifySignature(from, message, signature);
        require(firmaValidada, "Firma invalida.");

        _transfer(from, to, amount);
    }

}