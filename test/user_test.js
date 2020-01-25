const UserManager = artifacts.require("UserManager");
const Ballot = artifacts.require("Ballot");
contract('User Test', async (accounts) => {
  let instance;
  before(async () => {
    instance = await UserManager.deployed();
  });
  it("User Creation", async () => {
    await instance.createUser("leg0", {from: accounts[0]});
    let name = await instance.getUserName.call({from: accounts[0]});
    assert.equal(name, "leg0");
    // let allPolls = await instance.getAllPolls.call({from: accounts[0]});
    // assert.equal(allPolls, []);
    // let registeredPolls = await instance.getUserRegisteredPolls.call({from: accounts[0]});
    // assert.equal(registeredPolls, []);
    // let createdPolls = await instance.getUserCreatedPolls.call({from: accounts[0]});
    // assert.equal(createdPolls, []);
    // let votedPolls = await instance.getUserVotedPolls.call({from: accounts[0]});
    // assert.equal(votedPolls, []);
  });
  it("Poll Creation", async () => {
    let pollAddr = await instance.createNewPoll("CR", "CRE", "CRELECT", "NITT", {from: accounts[0]});
    console.log(pollAddr);
  })
  it("All Poll Check", async () => {
    let allPolls = await instance.getAllPolls.call({from: accounts[0]});
    console.log(allPolls);
  })
});