const HoneyPot = artifacts.require("./HoneyPot.sol");
const HoneyPotCollect = artifacts.require("./HoneyPotCollect.sol");

contract("HoneyPotCollect", (accounts) => {
  let instance = null;
  let honeypotContract = null;

  it("Retrieve deployed contract", async () => {
    instance = await HoneyPotCollect.deployed();
    honeypotContract = await HoneyPot.deployed();
    assert(honeypotContract != null, 'Honeypot contract is deployed');
    assert(instance != null, 'HoneyPotCollect contract is deployed');
  });

  it("Get balance of the contract", async () => {
    const res = await web3.eth.getBalance(honeypotContract.address);
    assert.equal(res.toString(10), '5000000000000000000', 'balance of Honeypot');
  });

  it("Attack HoneyPot contract", async () => {
    let fee = web3.toWei(0.5, "ether");
    let result = await instance.collect({from: accounts[1], value: fee});
    assert.equal('0x01', result.receipt.status, '');

    let res = await web3.eth.getBalance(honeypotContract.address);
    assert.equal(res.toString(10), '0', 'balance of Honeypot');

    result = await instance.kill({from: accounts[1]});
    assert.equal('0x01', result.receipt.status, '');
  });

});
