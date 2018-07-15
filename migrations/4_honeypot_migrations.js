var HoneyPot = artifacts.require("./HoneyPot.sol");

module.exports = function(deployer) {
  const fee = web3.toWei(5,"ether");
  deployer.deploy(HoneyPot, {value: fee});
};
