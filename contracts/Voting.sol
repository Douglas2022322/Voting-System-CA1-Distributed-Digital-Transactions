// SPDX-License-Identifier: MIT

// Example candidate list: ["Alice", "Bob", "Charlie"][12, 28, 22]

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

        // Events for logging key actions
    event NewVote(address indexed voter, uint indexed candidateNumber); // Emitted when a new vote is cast
    event VotingStarted();                                              // Emitted when voting starts
    event VotingEnded();                                                // Emitted when voting ends
    event VoterRegistered(address voter);                               // Emitted when a voter is registered

    // Constructor to initialize the contract with candidates and set admin
    constructor(string[] memory candidateNames, uint[] memory candidateNumbers) {
        require(candidateNames.length == candidateNumbers.length, "Candidates' names and numbers length must match");

        admin = msg.sender;  // Sets the contract creator as the admin
        votingActive = false; // Voting starts as inactive

        // Loop to add each candidate to the list
        for (uint i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate(candidateNames[i], candidateNumbers[i], 0));
            candidateIndexByNumber[candidateNumbers[i]] = i; // Map candidate number to index in array
            candidateExists[candidateNumbers[i]] = true;     // Mark candidate number as existing
        }
    }
}