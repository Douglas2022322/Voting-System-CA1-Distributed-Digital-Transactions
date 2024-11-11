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

    // Modifier to restrict function access to only the admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    // Modifier to ensure voting is active
    modifier onlyWhenVotingActive() {
        require(votingActive, "Voting is not active");
        _;
    }

    // Modifier to ensure that the voter is registered
    modifier onlyRegisteredVoter() {
        require(voters[msg.sender].isRegistered, "Voter is not registered");
        _;
    }

    // Function to start the voting process (only admin can start)
    function startVoting() external onlyAdmin {
        require(!votingActive, "Voting is already active");
        votingActive = true;
        emit VotingStarted(); // Emit event to indicate voting has started
    }

    // Function to end the voting process (only admin can end)
    function endVoting() external onlyAdmin {
        require(votingActive, "Voting is not active");
        votingActive = false;
        emit VotingEnded(); // Emit event to indicate voting has ended
    }

    // Function to register a new voter (only admin can register)
    function registerVoter(address _voter) external onlyAdmin {
        require(!voters[_voter].isRegistered, "Voter is already registered");
        voters[_voter].isRegistered = true;
        emit VoterRegistered(_voter); // Emit event when a voter is registered
    }

    // Function to vote for a candidate by their unique number
    // Only registered voters can vote, and voting must be active
    function vote(uint candidateNumber) public onlyWhenVotingActive onlyRegisteredVoter {
        require(!voters[msg.sender].hasVoted, "You have already voted!"); // Check if the voter has already voted
        require(candidateExists[candidateNumber], "Invalid candidate number!"); // Check if the candidate number is valid

        uint candidateIndex = candidateIndexByNumber[candidateNumber]; // Get candidate index by their number

        voters[msg.sender].hasVoted = true; // Mark the voter as having voted
        candidates[candidateIndex].voteCount += 1; // Increase the vote count for the chosen candidate
        
        emit NewVote(msg.sender, candidateNumber); // Emit event for a new vote
    }

    // Function to get the total number of candidates
    function getTotalCandidates() public view returns (uint) {
        return candidates.length;
    }

    // Function to get names and numbers of all candidates in a formatted string
    function getCandidates() public view returns (string memory) {
        string memory allCandidates = "";

        // Loop through candidates to format each candidate's details
        for (uint i = 0; i < candidates.length; i++) {
            allCandidates = string(abi.encodePacked(
                allCandidates,
                candidates[i].name,
                ", number ",
                uint2str(candidates[i].number),
                "; "
            ));
        }

        return allCandidates;
    }

    // Function to get the results of the election
    // Displays each candidate's name, vote count, and percentage of total votes
    function getResults() public view returns (string memory) {
        require(!votingActive, "Voting is still active"); // Ensure voting has ended before results are accessed
        uint totalVotes = 0;

        // Calculate total votes by summing up each candidate's vote count
        for (uint i = 0; i < candidates.length; i++) {
            totalVotes += candidates[i].voteCount;
        }

        string memory results = "";
        for (uint i = 0; i < candidates.length; i++) {
            uint voteCount = candidates[i].voteCount;
            uint percentage = totalVotes > 0 ? (voteCount * 100) / totalVotes : 0;

            // Format each candidate's results with name, vote count, and percentage
            results = string(abi.encodePacked(
                results,
                candidates[i].name,
                " = ",
                uint2str(voteCount),
                " votes (",
                uint2str(percentage),
                "%); "
            ));
        }

        return results;
    }

    // Helper function to convert uint to string
    function uint2str(uint _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
