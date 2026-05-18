// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {

    enum ConnectionTypes { 
        Unacquainted,
        Friend,
        Family
    }
    
    // Nested mapping:
    // address => address => ConnectionTypes
    mapping(address => mapping(address => ConnectionTypes)) public connections;

    function connectWith(address other, ConnectionTypes connectionType) external {
        // Create connection from msg.sender to other
        connections[msg.sender][other] = connectionType;
    }
}