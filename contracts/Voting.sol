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
}