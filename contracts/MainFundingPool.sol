//"SPDX-License-Identifier: MIT"
pragma solidity ^0.8.4;
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import './interfaces/IBPool.sol';
import './interfaces/IWeth.sol';

contract MainFundingPool {
    IBPool public bPool;
    IERC20 public dai;
    IERC20 public wbtc;
    IERC20 public usdc;
    IWeth public weth;

    constructor(address _bPool, address _dai, address _wbtc, address _usdc,address _weth) {
        bPool = IBPool(_bPool);
        dai = IERC20(_dai);
        wbtc = IERC20(_wbtc);
        usdc = IERC20(_usdc);
        weth = IWeth(_weth);
    }

    function swapEthForDai(uint daiAmount) external payable {
        weth.deposit{value: msg.value}();
        uint price = 110 * bPool.getSpotPrice(address(weth), address(dai)) / 100;
        uint wethAmount = price * daiAmount;
        weth.approve(address(bPool), wethAmount);
        bPool.swapExactAmountOut(
            address(weth), 
            wethAmount, 
            address(dai), 
            daiAmount, 
            price);
        dai.transfer(msg.sender, daiAmount);
        uint wethBalance = weth.balanceOf(address(this));
        if(wethBalance > 0){
            weth.withDraw(wethBalance);
            (bool success,) = msg.sender.call{ value: wethBalance }("");
            require(success, "ERR_ETH_FAILED");
        }
    }

    function getSpotPrice() external view  returns (uint){
        return bPool.getSpotPrice(address(weth), address(dai));
    }
}