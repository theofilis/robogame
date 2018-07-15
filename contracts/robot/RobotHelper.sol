pragma solidity ^0.4.23;

import "./RobotFactory.sol";

contract RobotHelper is RobotFactory {
    uint levelUpFee = 0.001 ether;

    modifier onlyOwnerOf(uint _robotId) {
        require(robotToOwner[_robotId] == msg.sender);
        _;
    }

    modifier aboveLevel(uint _robotId, uint _level) {
        require(robots[_robotId].level >= _level);
        _;
    }

    modifier isReady(uint _robotId) {
        require(robots[_robotId].readyTime <= block.number);
        _;
    }

    function triggerCooldown (Robot storage _robot) internal {
        _robot.readyTime = uint32(block.number + cooldownTime);
    }

    function levelUp(uint _robotId) external payable {
        require(msg.value == levelUpFee);
        robots[_robotId].level = robots[_robotId].level.add(1);
    }

    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    function changeName(uint _robotId, string _newName) external 
        onlyOwnerOf(_robotId)
        aboveLevel(_robotId, 2)
        isReady(_robotId)
    {        
        robots[_robotId].name = _newName;
        triggerCooldown(robots[_robotId]);
    }

    function changeDna(uint _robotId, uint _newDna) external 
        onlyOwnerOf(_robotId) 
        aboveLevel(_robotId, 20)
        isReady(_robotId)
    {
        robots[_robotId].dna = _newDna;
        triggerCooldown(robots[_robotId]);
    }

    function withdraw() external onlyOwner { 
        owner.transfer(address(this).balance);
    }

    function getRobotsByOwner(address _owner) external view returns(uint[]) {
        uint[] memory results = new uint[](ownerRobotCount[_owner]);

        uint counter = 0;
        for (uint i = 0; i < robots.length; i++) {
            if (robotToOwner[i] == _owner) {
                results[counter] = i;
                counter++;
            }
        }

        return results;
    }
}