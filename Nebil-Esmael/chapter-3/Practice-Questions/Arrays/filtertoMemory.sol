// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Contract {

    function filterEven(uint[] calldata numbers) external pure returns (uint[] memory) {

        uint count = 0;

        // First loop: count even numbers
        for (uint i = 0; i < numbers.length; i++) {
            if (numbers[i] % 2 == 0) {
                count++;
            }
        }

        // Create memory array with exact size
        uint[] memory evenNumbers = new uint[](count);

        uint index = 0;

        // Second loop: store even numbers
        for (uint i = 0; i < numbers.length; i++) {
            if (numbers[i] % 2 == 0) {
                evenNumbers[index] = numbers[i];
                index++;
            }
        }

        return evenNumbers;
    }
}