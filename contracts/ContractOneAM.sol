// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract ContractOneAM {
    // State Variables
    uint256 public count;
    string private message;
    // string[] private messages;
    bool private active;
    address public owner;

    // Events
    event MessageUpdated(uint256 count, string newMessage);
    event ErrorMessage(string errorMessage);

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "You're not the owner of the SC.");
        _;
    }

    // Constructor
    constructor() {
        count = 0;
        message = "Hello World!";
        active = true;
        owner = msg.sender;
    }

    // Functions
    // Función para actualizar el mensaje y el contador (solo si el SC está activo)
    function storeNewMessage(string memory _message) public {
        require(active == true, "The SC is not active.");
        count += 1;
        message = _message;
        // messages = messages.push(_message);
        emit MessageUpdated(count, _message);
    }

    // Función para obtener el mensaje (solo visible internamente y si el contrato está activo)
    function getMessage() public view returns (string memory) {
        require(active, "The SC is not active.");
        return message;
    }

    // // Función pública para obtener el mensaje de forma segura
    // function viewMensaje() public view returns (string memory) {
    //     try this.getMessage() returns (string memory resultado) {
    //         return resultado;
    //     } catch {
    //         emit ErrorMessage("Message can't be retrieved.");
    //         return "Error";            
    //     }
    // }

    // // Función pública para visualizar el mensaje.
    // function viewMessage() public view returns(string memory) {
    //     if (active) {
    //         return getMessage();
    //     } else {
    //         emit ErrorMessage("Message can't be retrieved.");
    //         return "Error";            
    //     }
    // }

    // Función para desactivar el contrato
    function deactivate() public onlyOwner {
        active = false;
    }
}
