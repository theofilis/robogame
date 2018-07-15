pragma solidity ^0.4.23;

import "./RobotOwnership.sol";

import "../auction/SaleClockAuction.sol";

/// @title Handles creating auctions for sale of robots.
///  This wrapper of ReverseAuction exists only so that users can create
///  auctions with only one transaction.
contract RobotAuction is RobotOwnership {

    // @notice The auction contract variables are defined in robotBase to allow
    //  us to refer to them in robotOwnership to prevent accidental transfers.
    // `saleAuction` refers to the auction for gen0 and p2p sale of robots.

    /// @dev Sets the reference to the sale auction.
    /// @param _address - Address of sale contract.
    function setSaleAuctionAddress(address _address) external onlyOwner {
        SaleClockAuction candidateContract = SaleClockAuction(_address);

        // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
        require(candidateContract.isSaleClockAuction());

        // Set the new contract address
        saleAuction = candidateContract;
    }

    /// @dev Put a robot up for auction.
    ///  Does some ownership trickery to create auctions in one tx.
    function createSaleAuction(
        uint256 _robotId,
        uint256 _startingPrice,
        uint256 _endingPrice,
        uint256 _duration
    )
        external
    {
        // Auction contract checks input sizes
        // If robot is already on any auction, this will throw
        // because it will be owned by the auction contract.
        require(_owns(msg.sender, _robotId));
        approve(saleAuction, _robotId);
        // Sale auction throws if inputs are invalid and clears
        // transfer and sire approval after escrowing the robot.
        saleAuction.createAuction(
            _robotId,
            _startingPrice,
            _endingPrice,
            _duration,
            msg.sender
        );
    }

    /// @dev Transfers the balance of the sale auction contract
    /// to the robotCore contract. We use two-step withdrawal to
    /// prevent two transfer calls in the auction bid function.
    function withdrawAuctionBalances() external onlyOwner {
        saleAuction.withdrawBalance();
    }
}
