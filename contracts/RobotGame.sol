pragma solidity ^0.4.23;

/**
 * @title SafeMath32
 * @dev SafeMath library implemented for uint32
 */
library SafeMath32 {

    function mul(uint32 a, uint32 b) internal pure returns (uint32) {
        if (a == 0) {
            return 0;
        }
        uint32 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint32 a, uint32 b) internal pure returns (uint32) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint32 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint32 a, uint32 b) internal pure returns (uint32) {
        assert(b <= a);
        return a - b;
    }

    function add(uint32 a, uint32 b) internal pure returns (uint32) {
        uint32 c = a + b;
        assert(c >= a);
        return c;
    }
}

/**
 * @title SafeMath16
 * @dev SafeMath library implemented for uint16
 */
library SafeMath16 {

    function mul(uint16 a, uint16 b) internal pure returns (uint16) {
        if (a == 0) {
            return 0;
        }
        uint16 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint16 a, uint16 b) internal pure returns (uint16) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint16 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint16 a, uint16 b) internal pure returns (uint16) {
        assert(b <= a);
        return a - b;
    }

    function add(uint16 a, uint16 b) internal pure returns (uint16) {
        uint16 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract ERC721 {
    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);

    function balanceOf(address _owner) public view returns (uint256 _balance);
    function ownerOf(uint256 _tokenId) public view returns (address _owner);
    function transfer(address _to, uint256 _tokenId) public;
    function approve(address _to, uint256 _tokenId) public;
    function takeOwnership(uint256 _tokenId) public;

    function totalSupply() public view returns (uint256 total);
    function transferFrom( address _from, address _to, uint256 _tokenId) public;

    // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
    function supportsInterface(bytes4 _interfaceID) external view returns (bool);

    // Optional
    // function name() public view returns (string name);
    // function symbol() public view returns (string symbol);
    // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
    // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
}



/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

contract RobotGame is Ownable, ERC721 {
    // RobotFactory
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

    function _createRobot(string _name, uint _dna) internal {
        uint id = robots.push(Robot(_name, _dna, 1, uint32(block.number + cooldownTime), 0, 0)) - 1;
        robotToOwner[id] = msg.sender;
        ownerRobotCount[msg.sender] = ownerRobotCount[msg.sender].add(1);
        emit NewRobot(id, _name, _dna);
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

    // RobotHelper

    uint levelUpFee = 0.001 ether;

    modifier onlyOwnerOf(uint _zombieId) {
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
        require(msg.value == levelUpFee);
        robots[_robotId].level++;
    }

    function withdraw() external onlyOwner {
        owner.transfer(address(this).balance);
    }

    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    function changeName(uint _robotId, string _newName) external aboveLevel(2, _robotId) onlyOwnerOf(_robotId) {
        robots[_robotId].name = _newName;
    }

    function changeDna(uint _robotId, uint _newDna) external aboveLevel(20, _robotId) onlyOwnerOf(_robotId) {
        robots[_robotId].dna = _newDna;
    }

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

    // RobotBattle
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

    // RobotOwnership
    mapping (uint => address) robotApprovals;

    function balanceOf(address _owner) public view returns (uint256 _balance) {
        _balance = ownerRobotCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address _owner) {
        _owner = robotToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerRobotCount[_to] = ownerRobotCount[_to].add(1);
        ownerRobotCount[_from] = ownerRobotCount[_from].sub(1);
        robotToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        _transfer(msg.sender, _to, _tokenId);
    }

    function transferFrom( address _from, address _to, uint256 _tokenId) public {
        _transfer(_from, _to, _tokenId);
    }

    function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
        return false;
    }

    function totalSupply() public view returns (uint256 total) {
        return 1000;
    }

    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        robotApprovals[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }

    function takeOwnership(uint256 _tokenId) public {
        require(robotApprovals[_tokenId] == msg.sender);
        address owner = ownerOf(_tokenId);
        _transfer(owner, msg.sender, _tokenId);
    }
}
