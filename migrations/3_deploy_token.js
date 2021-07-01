const TokenContract = artifacts.require("DogFundMeToken");
const Web3 = require('web3');
const Web3Utils = require('web3-utils');
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:9545'));

module.exports = function (deployer, network, accounts) {
    let initialSupply = Web3Utils.toBN("160000000000000000000000000000000");
    deployer.deploy(TokenContract, initialSupply);
};
