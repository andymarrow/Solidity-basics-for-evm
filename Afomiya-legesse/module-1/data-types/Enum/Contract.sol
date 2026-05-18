// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
    enum Foods {
        PIZZA,     // 0
        BURGER,    // 1
        SUSHI,     // 2
        PASTA      // 3
    }

    Foods public food1 = Foods.BURGER; // 1
    Foods public food2 = Foods.SUSHI;  // 2
    Foods public food3 = Foods.PASTA;  // 3
    Foods public food4 = Foods.PIZZA;  // 0

    // Sum = 1 + 2 + 3 + 0 = 6 ✅
}