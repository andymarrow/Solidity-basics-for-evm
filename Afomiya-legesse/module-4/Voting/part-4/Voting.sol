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

    function newProposal(address target, bytes calldata data) external {
        proposals.push(Proposal({
            target: target,
            data: data,
            yesCount: 0,
            noCount: 0
        }));
        emit ProposalCreated(proposals.length - 1);
    }

    function castVote(uint proposalId, bool support) external {
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