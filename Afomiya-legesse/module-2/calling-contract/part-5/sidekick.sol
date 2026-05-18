// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Sidekick {

    function sendAlert(
        address hero,
        uint enemies,
        bool armed
    ) external {

        bytes memory payload = abi.encodeWithSignature(
            "alert(uint256,bool)",
            enemies,
            armed
        );

        (bool success, ) = hero.call(payload);

        require(success, "call failed");
    }

    function makeContact(address hero) external {

        // random calldata that matches no function
        bytes memory payload = abi.encodeWithSignature("hello()");

        (bool success, ) = hero.call(payload);

        require(success, "contact failed");
    }
}