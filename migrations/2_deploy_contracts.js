const LGEContract = artifacts.require("LGEContract");

module.exports = function (deployer, network, accounts) {
    const owners = accounts.slice(0, 4);
    const numConfirmationsRequired = 2; 
    deployer.deploy(LGEContract, numConfirmationsRequired, owners);
};
