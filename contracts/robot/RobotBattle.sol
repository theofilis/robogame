pragma solidity ^0.4.23;

import "./RobotHelper.sol";

contract RobotBattle is RobotHelper {
    uint randNonce = 0;
    uint attackVictoryProbability = 70;

    function randMod(uint _modulus) internal returns(uint) {
        randNonce = randNonce.add(1);
        return uint(keccak256(block.number, msg.sender, randNonce)) % _modulus;
    }

    function attack(uint _robotId, uint _targetId) external onlyOwnerOf(_robotId) {
        Robot storage myRobot = robots[_robotId];
        Robot storage enemyRobot = robots[_targetId];

        uint rand = randMod(100);
        if (rand <= attackVictoryProbability) {
            myRobot.winCount = myRobot.winCount.add(1);
            myRobot.level = myRobot.level.add(1);
            enemyRobot.lossCount = enemyRobot.lossCount.add(1);
        } else {
            myRobot.lossCount = myRobot.lossCount.add(1);
            enemyRobot.winCount = enemyRobot.winCount.add(1);
            _triggerCooldown(myRobot);
        }
    }
}
