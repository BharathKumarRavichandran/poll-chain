pragma solidity >=0.4.21 <0.7.0;

import "./UserManager.sol";

contract Ballot {

    struct Candidate {
        string name;
        uint voteCount;
    }

    address owner;
    address parent;
    string ownerName;
    string pollName;
    string shortDescription;
    string longDescription;
    string eligibilityCriteria;
    uint[] times;
    Candidate[] candidates;
    bool resultsRevealed;

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the owner of the poll can do this."
        );
        _;
    }

    modifier onlyAuthorizedVoter(string memory token) {
        require(
            (now >= times[0] && now <= times[1]) && true, //TODO: Perform verirfication for token here
            "You are not authorized to participate in this poll"
        );
        _;
    }

    modifier ifResultsRevealed() {
        require(
            (resultsRevealed || now >= times[2]),
            "The results of the poll haven't been revealed yet"
        );
        _;
    }

    constructor (
        address oAddress,
        string memory oName,
        string memory pName,
        string memory sDescription,
        string memory lDescription,
        string memory eCriteria,
        string memory candidateOne,
        string memory candidateTwo
    ) public {
            parent = msg.sender;
            owner = oAddress;
            ownerName = oName;
            pollName = pName;
            shortDescription = sDescription;
            longDescription = lDescription;
            eligibilityCriteria = eCriteria;
            candidates.push(Candidate({
                name: candidateOne,
                voteCount: 0
            }));
            candidates.push(Candidate({
                name: candidateTwo,
                voteCount: 0
            }));
    }

    function setTimes (uint sTime, uint eTime, uint rTime) public {
        times[0] = sTime;
        times[1] = eTime;
        times[2] = rTime;
    }

    function uintToString (uint input) private pure returns (string memory) {
        bytes32 data = bytes32(input);
        bytes memory bytesString = new bytes(32);
        for (uint j = 0; j < 32; j++) {
            byte char = byte(bytes32(uint(data) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[j] = char;
            }
        }
        return string(bytesString);
    }

    function append(string memory a, string memory b) internal pure returns (string memory) {
        return string(abi.encodePacked(a, ";", b));
    }

    function getPollDetails() public view returns (string memory) {
        string memory details;
        details = append(ownerName, pollName);
        details = append(details, shortDescription);
        details = append(details, longDescription);
        details = append(details, eligibilityCriteria);
        details = append(details, uintToString(times[0]));
        details = append(details, uintToString(times[1]));
        details = append(details, uintToString(times[2]));
        for (uint i = 0; i < candidates.length; i++) {
            details = append(details, candidates[i].name);
        }
        return details;
    }

    function voteToPoll(string memory token, uint candidate) public onlyAuthorizedVoter(token) {
        candidates[candidate].voteCount++;
        UserManager(parent).updateVotedPolls(address(this), msg.sender);
    }

    function revealPollResults() public onlyOwner {
        resultsRevealed = true;
    }

    function viewPollResults() public view ifResultsRevealed returns (uint[] memory) {
        uint[] memory results;
        for (uint i = 0; i < candidates.length; i++) {
            results[i] = (candidates[i].voteCount);
        }
        return results;
    }

}