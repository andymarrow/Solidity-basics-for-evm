// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Contract {

    enum Choices { Yes, No }

    struct Vote {
        Choices choice;
        address voter;
    }

    mapping(address => Vote) public votes;
    mapping(address => bool) public hasVoted;

    function createVote(Choices choice) public {
        require(!hasVoted[msg.sender], "Already voted");

        votes[msg.sender] = Vote(choice, msg.sender);
        hasVoted[msg.sender] = true;
    }

    function changeVote(Choices choice) external {
        require(hasVoted[msg.sender], "No existing vote");
        votes[msg.sender].choice = choice;
    }

    function findChoice(address user) external view returns (Choices) {
        require(hasVoted[user], "No vote found");
        return votes[user].choice;
    }
}