// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Escrow {

    address public arbiter;
    address public depositor;
    address payable public beneficiary;

    event Approved(uint);

    constructor(
        address _arbiter,
        address payable _beneficiary
    ) payable {

        arbiter = _arbiter;
        beneficiary = _beneficiary;
        depositor = msg.sender;
    }

    function approve() external {

        require(
            msg.sender == arbiter,
            "only arbiter can approve"
        );

        uint balance = address(this).balance;

        beneficiary.transfer(balance);

        emit Approved(balance);
    }
}