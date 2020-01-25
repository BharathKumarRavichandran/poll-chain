pragma solidity >=0.4.21 <0.7.0;
import "./Ballot.sol";

contract UserManager {

    address[] allPolls;
    struct User {
        address[] createdPolls;
        address[] registeredPolls;
        address[] votedPolls;
        string name;
    }

    mapping(address => User) private allUsers;

    function createUser(string memory username) public {
        allUsers[msg.sender] = User({
            createdPolls: new address[](0),
            registeredPolls: new address[](0),
            votedPolls: new address[](0),
            name: username
        });
    }

    function getAllPolls() public view returns (address[] memory) {
        return allPolls;
    }

    function getUserName() public view returns (string memory) {
        return allUsers[msg.sender].name;
    }

    function getUserRegisteredPolls() public view returns (address[] memory) {
        return allUsers[msg.sender].registeredPolls;
    }

    function getUserCreatedPolls() public view returns (address[] memory) {
        return allUsers[msg.sender].createdPolls;
    }

    function getUserVotedPolls() public view returns (address[] memory) {
        return allUsers[msg.sender].votedPolls;
    }

    function registerForPoll(address poll) public {
        allUsers[msg.sender].registeredPolls.push(poll);
    }

    function createNewPoll(
        string memory pName,
        string memory sDescription,
        string memory lDescription,
        string memory eCriteria,
        string memory pCandidates
    ) public returns (address) {
        Ballot newPoll = new Ballot(allUsers[msg.sender].name, pName, sDescription, lDescription, eCriteria, pCandidates);
        allPolls.push(address(newPoll));
        allUsers[msg.sender].createdPolls.push(address(newPoll));
        return address(newPoll);
    }
}