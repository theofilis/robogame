var HoneyPot = artifacts.require("./HoneyPot.sol");
var HoneyPotCollect = artifacts.require("./HoneyPotCollect.sol");

module.exports = function(deployer) {
  deployer
    .then(() => HoneyPot.deployed())
    .then((instance) => {
      return deployer.deploy(HoneyPotCollect, instance.address);
    });
};
