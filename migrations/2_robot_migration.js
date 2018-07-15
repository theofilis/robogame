const SafeMath = artifacts.require("./SafeMath.sol");
const Ownable = artifacts.require("zeppelin-solidity/contracts/ownership/Ownable.sol");
const SafeMathAll = artifacts.require("zeppelin-solidity/contracts/math/SafeMath.sol");

const RobotMinting = artifacts.require("./robot/RobotMinting.sol");

module.exports = function(deployer) {
    deployer.deploy(SafeMath);
    deployer.deploy(SafeMathAll);
    deployer.link(SafeMath, RobotMinting);
    deployer.link(SafeMathAll, RobotMinting);
    deployer.deploy(RobotMinting);
};
