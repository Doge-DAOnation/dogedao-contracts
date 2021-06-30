// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract DogFundMeToken is ERC20{
    address _owner;
    uint _initialSupply;
    bool poolFunded = false;
    
    modifier onlyOwner(){
        require(msg.sender == _owner);
        _;
    }

    constructor(uint256 initialSupply) ERC20('DogFundMe', 'DFM'){
        _owner = msg.sender;
        _initialSupply = initialSupply;
        
        _mint(_owner, initialSupply);
    }
    
    function sendToPool(address bPAA, address uSPA, uint bPAPercentage, uint uSPAPercentage) external onlyOwner{
        require(!poolFunded && (bPAPercentage + uSPAPercentage) == 100);
        _transfer(_owner, bPAA, ((bPAPercentage/100) * _initialSupply));
        _transfer(_owner, uSPA, ((uSPAPercentage/100) * _initialSupply));
        poolFunded = true;
    }
}