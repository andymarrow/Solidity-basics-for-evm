// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {

    function double(uint256 x) public pure returns (uint256) {
        return x * 2;
    }

    function double(
        uint256 x,
        uint256 y
    ) public pure returns (uint256, uint256) {
        return (x * 2, y * 2);
    }
}