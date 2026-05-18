// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
    uint256 public a = 100;
    uint256 public b = 300;

    function sum() public view returns (uint256) {
        return a + b;
    }
}