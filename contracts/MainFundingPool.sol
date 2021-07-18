//"SPDX-License-Identifier: MIT"
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./interfaces/IBPool.sol";
import "./interfaces/IWeth.sol";

contract MainFundingPool {
    IBPool public bPool;
    IERC20 public dai;
    IERC20 public wbtc;
    IERC20 public usdc;
    IWeth public weth;

    constructor(
        address _bPool,
        address _dai,
        address _wbtc,
        address _usdc,
        address _weth
    ) {
        bPool = IBPool(_bPool);
        dai = IERC20(_dai);
        wbtc = IERC20(_wbtc);
        usdc = IERC20(_usdc);
        weth = IWeth(_weth);
    }

    function swapEthForDai(uint256 daiAmount) external payable {
        weth.deposit{value: msg.value}();
        uint256 price = (110 *
            bPool.getSpotPrice(address(weth), address(dai))) / 100;
        uint256 wethAmount = price * daiAmount;
        weth.approve(address(bPool), wethAmount);
        bPool.swapExactAmountOut(
            address(weth),
            wethAmount,
            address(dai),
            daiAmount,
            price
        );
        dai.transfer(msg.sender, daiAmount);
        uint256 wethBalance = weth.balanceOf(address(this));
        if (wethBalance > 0) {
            weth.withDraw(wethBalance);
            (bool success, ) = msg.sender.call{value: wethBalance}("");
            require(success, "ERR_ETH_FAILED");
        }
    }

    function getSpotPrice() external view returns (uint256) {
        return bPool.getSpotPrice(address(weth), address(dai));
    }

    function donate(address _tokenAddress, uint256 _amount) public payable {
        IERC20 erc20Token = IERC20(_tokenAddress);
        erc20Token.transferFrom(msg.sender, address(this), _amount);
    }
}
