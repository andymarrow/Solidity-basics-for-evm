
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {

    // Mapping of address to membership status
    mapping(address => bool) public members;

    // Add an address as a member
    function addMember(address _member) external {
        members[_member] = true;
    }

    // Check if an address is a member
    function isMember(address _member) external view returns (bool) {
        return members[_member];
    }

    // Remove an address from members
    function removeMember(address _member) external {
        members[_member] = false;
    }
}