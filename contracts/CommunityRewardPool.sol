//"SPDX-License-Identifier: MIT"
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CommunityRewardPool is Ownable {
    uint256 private fee;

    constructor() {
        fee = 40;
    }

    function setFee(uint256 _fee) public onlyOwner {
        fee = _fee;
    }

    function getFee() public view returns (uint256) {
        return fee;
    }
}
