pragma solidity ^0.4.23;

import "./RobotBattle.sol";
import "../ERC721.sol";
import "../SafeMath.sol";

///
/// https://github.com/ethereum/wiki/wiki/Ethereum-Natural-Specification-Format
///
/// @title A contract that manages transfering robot ownership
/// @author George Theofilis
/// @dev Compliant with OpenZeppelin's implementation of the ERC721 spec draft
///

contract RobotOwnership is RobotBattle, ERC721 {
    using SafeMath for uint256;

    bytes4 constant InterfaceSignature_ERC165 =
        bytes4(keccak256("supportsInterface(bytes4)"));

    bytes4 constant InterfaceSignature_ERC721 =
        bytes4(keccak256("name()")) ^
        bytes4(keccak256("symbol()")) ^
        bytes4(keccak256("totalSupply()")) ^
        bytes4(keccak256("balanceOf(address)")) ^
        bytes4(keccak256("ownerOf(uint256)")) ^
        bytes4(keccak256("approve(address,uint256)")) ^
        bytes4(keccak256("transfer(address,uint256)")) ^
        bytes4(keccak256("transferFrom(address,address,uint256)")) ^
        bytes4(keccak256("tokensOfOwner(address)")) ^
        bytes4(keccak256("tokenMetadata(uint256,string)"));

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

    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        robotApprovals[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }

    function takeOwnership(uint256 _tokenId) public {
        require(robotApprovals[_tokenId] == msg.sender);
        address owner = ownerOf(_tokenId);
        _transfer(owner, msg.sender, _tokenId);
    }

    function totalSupply() public view returns (uint256 total) {
        return 1000;
    }

    function transferFrom( address _from, address _to, uint256 _tokenId) public {
        _transfer(_from, _to, _tokenId);
    }

    /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
    ///  Returns true for any standardized interfaces implemented by this contract. We implement
    ///  ERC-165 (obviously!) and ERC-721.
    function supportsInterface(bytes4 _interfaceID) external view returns (bool)
    {
        return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
    }

    /// @dev Checks if a given address is the current owner of a particular Robot.
    /// @param _claimant the address we are validating against.
    /// @param _tokenId kitten id, only valid when > 0
    function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
        return robotToOwner[_tokenId] == _claimant;
    }

}
