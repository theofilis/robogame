pragma solidity ^0.4.23;

import "./RobotFactory.sol";

contract RobotHelper is RobotFactory {

    uint levelUpFee = 0.001 ether;

    modifier onlyOwnerOf(uint _zombieId) {
        // Task 1 Για να ελεχγουμε οτι εχε access μονο ο Ιδιοκτητης.
        // ** Start code here. 2 line approximately. **/
        require(msg.sender == robotToOwner[_zombieId]);
        _;
    }

    modifier aboveLevel(uint _level, uint _robotId) {
        require(robots[_robotId].level >= _level);
        _;
    }

    function _triggerCooldown(Robot storage _robot) internal {
        _robot.readyTime = uint32(block.number + cooldownTime);
    }

    function levelUp(uint _robotId) external payable {
        // Task 3 Πληρωνουμε για upgrade.
        // ** Start code here. 2 line approximately. **/
        require(msg.value == levelUpFee);
        robots[_robotId].level++;
    }

    function withdraw() external onlyOwner {
        // Task 4 Παιρνουμε τα έσοδα του contract.
        // ** Start code here. 1 line approximately. **/
        owner.transfer(address(this).balance);
    }

    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    // Task 5 Αλλάζουμε το ονομα του robot μας
    // ** Start code here. 3 line approximately. **/
    function changeName(uint _robotId, string _newName) external aboveLevel(2, _robotId) onlyOwnerOf(_robotId) {
        robots[_robotId].name = _newName;
    }

    function changeDna(uint _robotId, uint _newDna) external aboveLevel(20, _robotId) onlyOwnerOf(_robotId) {
        robots[_robotId].dna = _newDna;
    }

    // Task 6 Βρες όλα τα robot του χρήστη μας
    // ** Start code here. 11 line approximately. **/
    function getRobotsByOwner(address _owner) external view returns(uint[]) {
        uint[] memory result = new uint[](ownerRobotCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < robots.length; i++) {
            if (robotToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

}
