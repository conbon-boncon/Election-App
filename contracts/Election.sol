//"SPDX-License-Identifier: Unlicensed"

pragma solidity ^0.8.0;

contract Election {
    
    struct Candidate{
        string name;
        uint256 voteCount;
    }
     Candidate[] candidates;

    struct Voter{
        bool voted;
        uint8 vote;
    }
    mapping(address => Voter) voters;

    address owner;

    enum Stage{Registration, Voting, Results}
    Stage public stage;

    modifier onlyOwner() {
        require(msg.sender == owner, "Access Restricted");
        _;
    }

    constructor (){
        owner = msg.sender;
        stage = Stage.Registration;
    }

    function addCandidate(string memory _name) public onlyOwner {
        require(stage == Stage.Registration);
        candidates.push(Candidate({
            name: _name,
            voteCount:0
        }));
    }

    function registerVoters() public{
        require(stage == Stage.Registration && (msg.sender != owner));
        voters[msg.sender].voted = false;
    }

    function setStagetoVote() public onlyOwner(){
        require(stage == Stage.Registration);
        stage = Stage.Voting;
    }

    function vote(uint8 toCandidate) public {
        require(stage == Stage.Voting && voters[msg.sender].voted == false);
        voters[msg.sender].voted = true;
        voters[msg.sender].vote = toCandidate;
        candidates[toCandidate].voteCount ++;
    }

    function setStageToResults() public onlyOwner(){
        require(stage == Stage.Voting);
        stage = Stage.Results;
    }

    function winningCandidate() public returns(uint256 _winningCandidate){
        require(stage == Stage.Results);
        uint256 winVoteCount = 0;
        for(uint i =0; i< candidates.length; i++){
            if(candidates[i].voteCount > winVoteCount){
                winVoteCount = candidates[i].voteCount;
                _winningCandidate = i;
            }
        }
        stage = Stage.Registration;
    }

}