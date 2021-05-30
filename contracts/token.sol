pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract DogFundMeToken is ERC20{
    constructor(uint256 initialSupply) ERC20('DogFundMe', 'DFM'){
        _mint(msg.sender, initialSupply);
    }
}