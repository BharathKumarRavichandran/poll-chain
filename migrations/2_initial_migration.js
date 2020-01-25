var UserManager = artifacts.require("./UserManager.sol");
var Ballot = artifacts.require("./Ballot.sol");

module.exports = function(deployer) {
  deployer.deploy(UserManager);
};