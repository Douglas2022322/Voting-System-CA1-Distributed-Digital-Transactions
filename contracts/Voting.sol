// SPDX-License-Identifier: MIT



pragma solidity ^0.8.7;

contract Voting {
    
    // Structure to represent a candidate
    struct Candidate {
        string name;        // Name of the candidate
        uint number;        // Unique number identifier for the candidate
        uint voteCount;     // Number of votes received by the candidate
    }

    // Structure to represent a voter
    struct Voter {
        bool isRegistered;  // Whether the voter is registered
        bool hasVoted;      // Whether the voter has already voted
    }

        // List of candidates
    Candidate[] private candidates;
    
    // Mapping to store voter information by address
    mapping(address => Voter) public voters;

    // Mapping to find a candidate's index by their number
    mapping(uint => uint) private candidateIndexByNumber;

    // Mapping to check if a candidate number exists
    mapping(uint => bool) private candidateExists;
    
    // Administrator's address (contract creator)
    address public admin;

    // Voting status
    bool public votingActive;
}