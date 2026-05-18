// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {
    struct Proposal {
        address target;
        bytes data;
        uint yesCount;
        uint noCount;
    }

    struct Vote {
        bool hasVoted;
        bool votedYes;
    }

    event ProposalCreated(uint proposalId);
    event VoteCast(uint proposalId, address voter);

    Proposal[] public proposals;
    mapping(uint => mapping(address => Vote)) private votes;
    mapping(address => bool) public members;

    constructor(address[] memory _members) {
        members[msg.sender] = true;
        for (uint i = 0; i < _members.length; i++) {
            members[_members[i]] = true;
        }
    }

    modifier onlyMember() {
        require(members[msg.sender], "Not a voting member");
        _;
    }

    function newProposal(address target, bytes calldata data) external onlyMember {
        proposals.push(Proposal({
            target: target,
            data: data,
            yesCount: 0,
            noCount: 0
        }));
        emit ProposalCreated(proposals.length - 1);
    }

    function castVote(uint proposalId, bool support) external onlyMember {
        Proposal storage proposal = proposals[proposalId];
        Vote storage vote = votes[proposalId][msg.sender];

        if (vote.hasVoted) {
            if (vote.votedYes) {
                proposal.yesCount--;
            } else {
                proposal.noCount--;
            }
        }

        if (support) {
            proposal.yesCount++;
        } else {
            proposal.noCount++;
        }

        vote.hasVoted = true;
        vote.votedYes = support;

        emit VoteCast(proposalId, msg.sender);
    }
}