//"SPDX-License-Identifier: MIT"
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/access/Ownable.sol";

contract VariableManager is Ownable {
    uint256 private _poolFee;
    uint256 private _mainFundingPoolFee;
    uint256 private _decimals;

    constructor() {
        _poolFee = 200;
        _mainFundingPoolFee = 160;
        _decimals = 10000;
    }

    function setFees(
        uint256 _poolFee_,
        uint256 _mainFundingPoolFee_,
        uint256 _decimals_
    ) public onlyOwner {
        require(_poolFee_ < _decimals_, "DD: Overflow pool fee.");
        require(
            _poolFee_ > _mainFundingPoolFee,
            "DD: Overflow main funding pool fee."
        );
        _poolFee = _poolFee_;
        _mainFundingPoolFee = _mainFundingPoolFee_;
        _decimals = _decimals_
    }

    function setMainFundingPoolFee(uint256 _mainFundingPoolFee_)
        public
        onlyOwner
    {
        require(
            _mainFundingPoolFee_ < _poolFee,
            "DD: Overflow main funding pool fee."
        );
        _mainFundingPoolFee = _mainFundingPoolFee_;
    }

    function decimals() public view returns (uint256) {
        return _decimals;
    }

    function poolFee() public view returns (uint256) {
        return _poolFee;
    }

    function mainFundingPoolFee() public view returns (uint256) {
        return _mainFundingPoolFee;
    }

    function comunityRewardPoolFee() public view returns (uint256) {
        return (_poolFee - _mainFundingPoolFee);
    }
}
