// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
    int8 public a = 10;
    int8 public b = -5;

    function difference() public view returns (int16) {
        int16 diff = int16(a) - int16(b);

        if (diff < 0) {
            diff = -diff;
        }

        return diff;
    }
}