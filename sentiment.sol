// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SentimentBasedVoting {
    address public owner;
    mapping(address => uint256) public votes;
    mapping(address => bool) public hasVoted;

    uint256 public positiveVotes;
    uint256 public negativeVotes;

    // Predefined sentiment results (1 for positive, 0 for negative)
    mapping(address => uint8) private sentimentResults;

    // Set the contract deployer as the owner
    function setOwner() public {
        require(owner == address(0), "Owner already set");
        owner = msg.sender;
    }

    // Set sentiment result (0 for negative, 1 for positive)
    function setSentimentResult(address voter, uint8 sentiment) public {
        require(msg.sender == owner, "Only owner can set sentiment results");
        require(sentiment == 0 || sentiment == 1, "Invalid sentiment value");
        sentimentResults[voter] = sentiment;
    }

    // Vote based on sentiment analysis
    function castVote() public {
        require(!hasVoted[msg.sender], "You have already voted");
        require(sentimentResults[msg.sender] == 0 || sentimentResults[msg.sender] == 1, "No sentiment analysis available");

        hasVoted[msg.sender] = true;

        if (sentimentResults[msg.sender] == 1) {
            positiveVotes += 1;
        } else {
            negativeVotes += 1;
        }
    }

    // Get voting results
    function getResults() public view returns (uint256, uint256) {
        return (positiveVotes, negativeVotes);
    }

    // Reset voting (can only be done by owner)
    function resetVoting() public {
        require(msg.sender == owner, "Only owner can reset voting");

        positiveVotes = 0;
        negativeVotes = 0;
    }
}
