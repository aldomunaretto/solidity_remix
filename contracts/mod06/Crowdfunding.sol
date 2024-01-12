// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract CrowdfundingNFT is ERC721Enumerable {
    constructor() ERC721("CrowdfundingNFT", "CFNFT") {}

    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
    }
}

contract Crowdfunding {
    address public organizador;
    uint256 public objetivoFondos;
    uint256 public plazoFinal;
    uint256 public totalRecaudado;
    CrowdfundingNFT public nft;
    uint256 public nextTokenId;

    mapping(address => uint256) public contribuciones;

    event ContribucionRealizada(address contribuyente, uint256 cantidad, uint256 tokenId);
    event FondosRetirados(address organizador, uint256 cantidad);

    error CrowdfundingFinalizado();
    error ObjetivoAlcanzado();
    error NoEsElOrganizador();
    error ContribucionNoPosible();

    constructor(uint256 _objetivoFondos, uint256 _duracion) {
        organizador = msg.sender;
        objetivoFondos = _objetivoFondos;
        plazoFinal = block.timestamp + _duracion;
        nft = new CrowdfundingNFT();
    }

    function contribuir() public payable {
        if (block.timestamp > plazoFinal) revert CrowdfundingFinalizado();
        if (totalRecaudado >= objetivoFondos) revert ObjetivoAlcanzado();

        contribuciones[msg.sender] += msg.value;
        totalRecaudado += msg.value;

        uint256 tokenId = nextTokenId++;
        nft.mint(msg.sender, tokenId);
        emit ContribucionRealizada(msg.sender, msg.value, tokenId);
    }

    function retirarFondos() public {
        if (msg.sender != organizador) revert NoEsElOrganizador();
        if (totalRecaudado < objetivoFondos) revert ContribucionNoPosible();

        uint256 cantidadRetirada = address(this).balance;
        payable(organizador).transfer(cantidadRetirada);
        emit FondosRetirados(organizador, cantidadRetirada);
    }
}
