//"SPDX-License-Identifier: MIT"
pragma solidity ^0.8.4;

interface IWeth {
    function deposit() external payable;
    function withDraw(uint wad) external;
    function approve(address guy, uint wad) external returns(bool);
    function balanceOf(address guy) external view returns(uint);
}