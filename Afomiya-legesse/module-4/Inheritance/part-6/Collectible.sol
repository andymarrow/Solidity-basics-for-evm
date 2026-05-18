// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Transferable.sol";

contract Collectible is Transferable {
    uint public price;

    function markPrice(uint _price) external onlyOwner {
        price = _price;
    }
}