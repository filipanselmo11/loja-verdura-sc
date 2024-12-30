const LojaDeVerduras = artifacts.require("LojaDeVerduras");

module.exports = function (deployer) {
  deployer.deploy(LojaDeVerduras, { gas: 5000000 });
};