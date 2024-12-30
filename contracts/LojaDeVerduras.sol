// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract LojaDeVerduras {
    struct Produto {
        string nome;
        uint256 preco;
        uint256 quantidade;
    }

    mapping(uint256 => Produto) public produtos;
    uint256 public proximoId;

    address public owner;

    constructor() {
        owner = msg.sender;
        require(owner != address(0), "Endereco do dono invalido");
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Apenas o dono pode executar esta acao");
        _;
    }

    modifier produtoExiste(uint256 id) {
        require(bytes(produtos[id].nome).length > 0, "Produto nao encontrado");
        _;
    }

    function addProduto(
        string memory nome,
        uint256 preco,
        uint256 quantidade
    ) public onlyOwner {
        require(preco > 0, "Preco deve ser maior que zero");
        require(quantidade > 0, "Quantidade deve ser maior que zero");
        produtos[proximoId] = Produto(nome, preco, quantidade);
        proximoId++;
    }

    function comprarProduto(uint256 id) public payable produtoExiste(id) {
        Produto storage produto = produtos[id];
        require(produto.quantidade > 0, "Produto esgotado");
        require(msg.value >= produto.preco, "Valor insuficiente para compra");

        produto.quantidade -= 1;

        // Transferência para o proprietário
        (bool enviado, ) = payable(owner).call{value: msg.value}("");
        require(enviado, "Falha na transferencia de ETH");
    }

    function obterProduto(
        uint256 id
    ) public view produtoExiste(id) returns (string memory, uint256, uint256) {
        Produto storage produto = produtos[id];
        return (produto.nome, produto.preco, produto.quantidade);
    }
}
