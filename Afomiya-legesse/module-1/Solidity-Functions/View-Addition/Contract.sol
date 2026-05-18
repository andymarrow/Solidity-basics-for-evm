// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
    uint256 public x;

    constructor(uint256 _x) {
        x = _x;
    }

    function increment() public {
        x += 1;
    }

    function add(uint256 y) public view returns (uint256) {
        return x + y;
    }
}