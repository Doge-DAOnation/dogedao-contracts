const LGEContract = artifacts.require("LGEContract");

module.exports = function (deployer, network, accounts) {
    const numConfirmationsRequired = 2; 
    deployer.deploy(LGEContract, numConfirmationsRequired);
};
