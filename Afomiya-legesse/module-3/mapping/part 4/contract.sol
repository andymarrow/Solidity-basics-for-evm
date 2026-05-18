// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
    
    struct User {
        uint balance;
        bool isActive;
    }

    // Mapping address to User struct
    mapping(address => User) public users;

    // Create a new user
    function createUser() external {
        // Make sure the user is not already active
        require(!users[msg.sender].isActive, "User already exists");

        // Create and store the new user
        users[msg.sender] = User({
            balance: 100,
            isActive: true
        });
    }

    // Transfer balance from sender to recipient
    function transfer(address recipient, uint amount) external {
        // Ensure both users are active
        require(users[msg.sender].isActive, "Sender is not active");
        require(users[recipient].isActive, "Recipient is not active");

        // Ensure sender has enough balance
        require(users[msg.sender].balance >= amount, "Insufficient balance");

        // Transfer the amount
        users[msg.sender].balance -= amount;
        users[recipient].balance += amount;
    }
}