pragma solidity >=0.4.21 <0.7.0;
import "./Ballot.sol";

contract UserManager {

    address[] allPolls;
    struct User {
        address[] createdPolls;
        address[] registeredPolls;
        address[] votedPolls;
        mapping(address => bytes32) txnHashes;
        string name;
    }

    event registeredForNewPoll(
        address poll,
        address user
    );

    event createdNewPoll(
        address poll
    );

    event votedForNewPoll(
        address poll,
        address user
    );

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

    function getTxnHashForPoll(address poll) public view returns (bytes32) {
        return allUsers[msg.sender].txnHashes[poll];
    }

    function updateTxnHashForPoll(address poll, bytes32 txnHash) public {
        allUsers[msg.sender].txnHashes[poll] = txnHash;
    }

    function registerForPoll(address poll) public {
        allUsers[msg.sender].registeredPolls.push(poll);
    }

    function updateVotedPolls(address poll, address user) public {
        allUsers[user].votedPolls.push(poll);
    }

    function createNewPoll(
        string memory pName,
        string memory sDescription,
        string memory lDescription,
        string memory eCriteria,
        string memory candidateOne,
        string memory candidateTwo
    ) public {
        Ballot newPoll = new Ballot(msg.sender, allUsers[msg.sender].name, pName, sDescription,
            lDescription, eCriteria, candidateOne, candidateTwo);
        allPolls.push(address(newPoll));
        allUsers[msg.sender].createdPolls.push(address(newPoll));
        emit createdNewPoll(address(newPoll));
    }
}