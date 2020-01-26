pragma solidity >=0.4.21 <0.7.0;

import "./DateTimeLibrary.sol";
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
        string memory pollCandidates
    ) public {
            parent = msg.sender;
            owner = oAddress;
            ownerName = oName;
            pollName = pName;
            shortDescription = sDescription;
            longDescription = lDescription;
            eligibilityCriteria = eCriteria;
            // var s = pollCandidates.toSlice();
            // var delim = ";".toSlice();
            // var parts = new string[](s.count(delim) + 1);
            // for(uint i = 0; i < parts.length; i++) {
            //     candidates.push(Candidate({
            //         name: s.split(delim).toString(),
            //         voteCount: 0
            //     }));
            // }
    }

    function setStartTime(uint sYear, uint sMonth, uint sDay, uint sHour, uint sMinute) public {
        times[0] = DateTimeLibrary.timestampFromDateTime(sYear, sMonth, sDay, sHour, sMinute, 0);
    }

    function setEndTime(uint eYear, uint eMonth, uint eDay, uint eHour, uint eMinute) public {
        times[1] = DateTimeLibrary.timestampFromDateTime(eYear, eMonth, eDay, eHour, eMinute, 0);
    }

    function setRevealTime(uint rYear, uint rMonth, uint rDay, uint rHour, uint rMinute) public {
        times[2] = DateTimeLibrary.timestampFromDateTime(rYear, rMonth, rDay, rHour, rMinute, 0);
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
        // TODO: Return txn id for future verification
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