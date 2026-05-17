// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Contract {

    struct User {
        uint balance;
        bool isActive;
    }

    mapping(address => User) public users;

    function createUser() external {
        require(!users[msg.sender].isActive, "User already exists");

        users[msg.sender] = User({
            balance: 100,
            isActive: true
        });
    }

    function transfer(address to, uint amount) external {
        require(users[msg.sender].isActive, "Sender not active");
        require(users[to].isActive, "Recipient not active");
        require(users[msg.sender].balance >= amount, "Insufficient balance");

        users[msg.sender].balance -= amount;
        users[to].balance += amount;
    }
}