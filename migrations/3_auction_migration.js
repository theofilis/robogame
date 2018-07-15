const RobotMinting = artifacts.require("./robot/RobotMinting.sol");
const SaleClockAuction = artifacts.require("./auction/SaleClockAuction.sol");

module.exports = function(deployer) {
    deployer
    .then(() => RobotMinting.deployed())
    .then((instance) => {
        // const fee = web3.toWei(1, "ether");
        // deployer.deploy(SaleClockAuction, instance.address, 2000, {value: fee})
        return deployer.deploy(SaleClockAuction, instance.address, 2000);
    });
};
