const LGEContract = artifacts.require('LGEContract');
const Web3 = require('web3');
const Web3Utils = require('web3-utils');
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:9545'));

contract ('LGEContract', (accounts) => {
    let lgeContract;

    before(async () => {
        lgeContract = await LGEContract.deployed();
    });

    /** Truffle accounts
     * "0xe775209d747904D406b70CEfB97E10Ef393F88a0"
     * "0xe775209d747904D406b70CEfB97E10Ef393F88a0"
     * "0x9BBbAcBDE8fBAC3F5784F30C1110002Ee198BdfE"
     * "0x13e1A9A2A62B883bd3aAb71e6D240Ba10A70eC8A"
     * "0xb2EAFc933ce0420FCafaF278d485Ac4536D84e6a"
     * **/
    
    describe('Deployment', async () =>{
        it('LGE DUO is deployed Sucessfully', async () => {
            const address = await lgeContract.address;
            console.log(address);
            assert.notEqual(address, 0x0);
            assert.notEqual(address, null);
            assert.notEqual(address, undefined);
            assert.notEqual(address, '');
        });
        it('Has Owner', async () => {
            const owner = await lgeContract._owner;
            assert.notEqual(owner, 0x0);
            assert.notEqual(owner, null);
            assert.notEqual(owner, undefined);
            assert.notEqual(owner, '');
        });
        it('Has Confirmations', async () => {
            const confirmations = await lgeContract._min_confirmation;
            assert.notEqual(confirmations, 0)
            assert.notEqual(confirmations, 1)
            assert.notEqual(confirmations, 3)
        });
    });

     describe('Get Contract Balance TestCases!', async () => {
         let balance;
         it('Checking with different accounts', function() {
             return LGEContract.deployed().then(function (instance) {
                 lgeContract = instance;
                 return lgeContract.getContractBalance.call({from: accounts[6]});
             }).then(assert.fail).catch(function(error){
                 assert(error.message.indexOf('revert') >= 0, 'error for revert on account address of 5th index!')
                 return lgeContract.getContractBalance.call({from: accounts[0]});
             }).then(function (success){
                 assert.equal(success, 0, 'When called from one of harverster/founder balance is correct');
             });
         })
     });

     describe('Add Liquidity', async() => {
         it('Trying it with different values to ether and different senders', function() {
             return LGEContract.deployed().then(function(instance) {
                 lgeContract = instance;
                 //1 eth = 1000000000000000000
                 return lgeContract.addLiquidity({from: accounts[7], value: 12});
             }).then(assert.fail).catch(function(error) {
                 assert(error.message.indexOf('revert' >= 0, 'error is because the amount is not correct'));
                 return lgeContract.addLiquidity({from: accounts[7], value: 1000000000000000000});
             }).then(function() {
                // assert.equal(lgeContract.liquidityProviders(accounts[7]),1000000000000000000);
                return lgeContract.liquidityProviders(accounts[7]);
             }).then(function(value) {
                 assert.equal(value, 1000000000000000000, 'Value is correct');
             });
         });
     });
     
     describe('Change Contract State', async() => {
        it('Changing state from active to inactive and vise-versa, trying adding liquidity', function(){
           return lgeContract.updateContractState(2)
            .then(assert.fail).catch(function(error) {
                assert(error.message.indexOf('revert' >= 0), 'Invalid type');
                return lgeContract.updateContractState(1);
            }).then(function() {
                // return lgeContract.liquidityProviders(accounts[7]);
                return lgeContract.addLiquidity({from: accounts[8], value: 1000000000000000000});
            }).then(assert.fail).catch(function(error) {
                assert(error.message.indexOf('revert' >= 0, 'The Contract is inactive. Lets active and try again'));
                return lgeContract.updateContractState(0);
            }).then(function() {
                return lgeContract.addLiquidity({from: accounts[8], value: 1000000000000000000});
            }).then(function() {
                return lgeContract.liquidityProviders(accounts[8]);
            }).then(function(value) {
                //checking balance of liquidity funder
                assert.equal(value, 1000000000000000000, 'Value is correct');
            })
        });
    });
    describe('Harvesting', async()=> {
        it('Testing for higher values, ', function(){
        return lgeContract.createHarvestRequest(Web3Utils.toBN("160000000000000000000"), {from: accounts[9]})
            .then(assert.fail).catch(function(error) {
                assert(error.message.indexOf('revert' >= 0, 'Invalid Harvester'));
                return lgeContract.createHarvestRequest(Web3Utils.toBN("160000000000000000000"),{from: accounts[2]});
            }).then(assert.fail).catch(function(error) {
                assert(error.message.indexOf('revert' >=0, 'Invalid Amount'));
                return lgeContract.createHarvestRequest(Web3Utils.toBN("1000000000000000000"), {from: accounts[2]})
            })
        });
        it('Approving Harvest Requests', function() {
            return lgeContract.approveHarvestRequest(0, {from: accounts[0]})
             .then(function(){
                 return lgeContract.approveHarvestRequest(0, {from: accounts[5]})
             }).then(assert.fail).catch(function(error){
                 assert(error.message.indexOf('revert' >= 0, 'Invalid Approver!'))
                 return lgeContract.approveHarvestRequest(50, {from: accounts[0]})
             }).then(assert.fail).catch(function(error1){
                assert(error1.message.indexOf('revert' >= 0, 'Invalid Request ID!'))
                lgeContract.approveHarvestRequest(0, {from: accounts[1]})
                return lgeContract.approveHarvestRequest(0, {from: accounts[2]})
            }).then(function() {
                 //harvest_rqst_arr
                 return lgeContract.getHarvestRequest({from: accounts[6]})
             }).then(assert.fail).catch(function(err){
                 assert(err.message.indexOf('revert' >= 0, 'Invalid Sender, it can only be harvester..'));
                 return lgeContract.getHarvestRequest({from: accounts[0]})
             }).then(function(harverster_array) {
                 console.log(harverster_array.length)
                 console.log(harverster_array[0].address);
                 console.log(harverster_array[0].value);
                 console.log(harverster_array[0].no_of_confirmations);
                 console.log(harverster_array[0].executed);
                 console.log(harverster_array[0].active);
             })
        });
    });
});