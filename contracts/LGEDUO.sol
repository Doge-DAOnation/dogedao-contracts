pragma solidity ^0.8.4;

contract LGEContract{
    
    event HarvestRequestApproval(uint request_id);
    
    address public _owner;
    
    mapping (address => bool) private harvesters;
    
    address[] harvesters_arr;
    
    address[] liquidityProviders_arr;
    
    uint _min_confirmation;
    
    mapping (address => uint) public liquidityProviders;
    
    mapping (uint => harvestRequest) public harvestRequests;
    
    //this maps the harvest request id to addresses that have confirmed request. Neccessary to ensure no address verifies a request more than once
    mapping(uint => mapping(address => bool)) confirmers;
    
   harvestRequest[] harvest_rqst_arr;
   
    struct harvestRequest{
        address initiator;
        uint value;
        uint no_of_confirmations;
        bool executed;
        bool active;
        address payable withdraw_addres;
    }
    
    enum contractStateEnum {
        active,
        paused
    }
    
    contractStateEnum public _cState = contractStateEnum.active;
    

    modifier onlyOwner(){
        require(msg.sender == _owner);
        _;
    }
    
    modifier isActiveHarvestRequest(uint harvest_id){
        require(harvestRequests[harvest_id].active, "Supplied harvest request is currently not active");
        _;
    }
    
    modifier onlyHarvester(){
        require(harvesters[msg.sender]);
        _;
    }

    constructor (uint min_confirmation,address[] memory founders){
        require(founders.length < 5, "Exceeded maximum number of founders");
        _owner = msg.sender;
        harvesters[msg.sender] = true;
        harvesters_arr.push(msg.sender);
        _min_confirmation = min_confirmation;
        uint i;
        for(i = 0 ; i < founders.length; i++){
            require(!harvesters[founders[i]]);
            harvesters[founders[i]] = true;
            harvesters_arr.push(founders[i]);
        }
        
    }
    
    function getContractBalance() public view onlyHarvester returns(uint){
        return address(this).balance;
    }
    
    function addLiquidity() payable public{
        require(msg.value >= 1 ether, "Please provide minimum amount of 1 ether");
        require(_cState == contractStateEnum.active, "Not currently accepting liquidity, check back in a future time");
        if(liquidityProviders[msg.sender] == 0){
            liquidityProviders_arr.push(msg.sender);
        }
        liquidityProviders[msg.sender] += msg.value;
        return;
    }
    
    function getLiquidityProviders() public view returns(address[] memory){
        return liquidityProviders_arr;
    }
    
    function updateContractState(uint _status) public onlyHarvester{
        require(_status <= 1);
        _cState = contractStateEnum(_status);
        return;
    }
    
    function getHarvesters() external view returns(address[] memory){
        return harvesters_arr;
    }
    
    function createHarvestRequest(uint _value, address payable _withdraw_address ) public onlyHarvester{
        require(_value < address(this).balance, "Request amount above contract balance");
        harvestRequests[harvest_rqst_arr.length] = harvestRequest({
            initiator: msg.sender,
            value: _value,
            no_of_confirmations: 0,
            executed: false,
            active: true,
            withdraw_addres: _withdraw_address
        });
        
        harvest_rqst_arr.push(harvestRequests[harvest_rqst_arr.length]);
    }
    
    function approveHarvestRequest(uint harvest_id) public onlyHarvester isActiveHarvestRequest(harvest_id){
        
        require(harvest_id <= harvest_rqst_arr.length);
        require(!confirmers[harvest_id][msg.sender]);
        harvestRequests[harvest_id].no_of_confirmations += 1;
        
        //update the confirmers 
        confirmers[harvest_id][msg.sender] = true;
        
        //if the request has exceeded the applied threshhold, emit event
        if(harvestRequests[harvest_id].no_of_confirmations >= _min_confirmation){
            emit HarvestRequestApproval(harvest_id);
        }
    }
    
    function revokeHarvestRequest(uint harvest_id) public onlyHarvester isActiveHarvestRequest(harvest_id){
        require(harvestRequests[harvest_id].initiator == msg.sender);
        harvestRequests[harvest_id].active = false;
    }
    
    function resetHarvestRequestStatus(uint harvest_id) public onlyHarvester{
        require(harvestRequests[harvest_id].initiator == msg.sender, "You can only update request created by you");
        harvestRequests[harvest_id].active = false;
    }
    
    function getHarvestRequest()public view onlyHarvester returns(harvestRequest[] memory){
        return harvest_rqst_arr;
    }
    
    function harvestLiquidity(uint harvest_request_id)public onlyHarvester isActiveHarvestRequest(harvest_request_id){
        require(harvestRequests[harvest_request_id].no_of_confirmations >= _min_confirmation);
        require(harvestRequests[harvest_request_id].initiator == msg.sender);
        uint value = harvestRequests[harvest_request_id].value;
        harvestRequests[harvest_request_id].withdraw_addres.transfer(value);
        harvestRequests[harvest_request_id].executed = true;
    }
}