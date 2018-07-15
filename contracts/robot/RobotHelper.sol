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

    function levelUp(uint _robotId) external payable {
        require(msg.value == levelUpFee);
        robots[_robotId].level++;
    }

    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    function changeName(uint _robotId, string _newName) external 
        onlyOwnerOf(_robotId)
        aboveLevel(_robotId, 2)
    {        
        robots[_robotId].name = _newName;
    }

    function changeDna(uint _robotId, uint _newDna) external 
        onlyOwnerOf(_robotId) 
        aboveLevel(_robotId, 20) 
    {
        robots[_robotId].dna = _newDna;
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