pragma solidity ^0.4.23;

import "../SafeMath.sol";

import "../auction/SaleClockAuction.sol";

import "../../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol";
import "../../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol";

contract RobotFactory is Ownable {
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    event NewRobot(uint robotId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1000;

    struct Robot {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    Robot[] public robots;

    mapping (uint => address) public robotToOwner;
    mapping (address => uint) ownerRobotCount;

    /// @dev The address of the ClockAuction contract that handles sales of Kitties. This
    ///  same contract handles both peer-to-peer sales as well as the gen0 sales which are
    ///  initiated every 15 minutes.
    SaleClockAuction public saleAuction;

    function _createRobot(string _name, uint _dna) internal {
        uint id = robots.push(Robot(_name, _dna, 1, uint32(block.number + cooldownTime), 0, 0)) - 1;
        robotToOwner[id] = msg.sender;
        ownerRobotCount[msg.sender] = ownerRobotCount[msg.sender].add(1);

        emit NewRobot(id, _name, _dna);
    }

    function _createRobot(string _name, uint _dna, address _owner) internal returns (uint) {
        uint id = robots.push(Robot(_name, _dna, 1, uint32(block.number + cooldownTime), 0, 0)) - 1;
        robotToOwner[id] = _owner;
        ownerRobotCount[_owner] = ownerRobotCount[_owner].add(1);

        emit NewRobot(id, _name, _dna);

        return id;
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomRobot(string _name) public {
        require(ownerRobotCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createRobot(_name, randDna);
    }

}
