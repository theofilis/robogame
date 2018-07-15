pragma solidity ^0.4.23;

import "./RobotAuction.sol";


/// @title all functions related to creating robots
contract RobotMinting is RobotAuction {

    // Limits the number of cats the contract owner can ever create.
    uint256 public constant PROMO_CREATION_LIMIT = 5000;
    uint256 public constant GEN0_CREATION_LIMIT = 45000;

    // Constants for gen0 auctions.
    uint256 public constant GEN0_STARTING_PRICE = 10 finney;
    uint256 public constant GEN0_AUCTION_DURATION = 1 days;

    // Counts the number of cats the contract owner has created.
    uint256 public promoCreatedCount;
    uint256 public gen0CreatedCount;

    /// @dev we can create promo robots, up to a limit. Only callable by Owner
    /// @param _genes the encoded genes of the robot to be created, any value is accepted
    /// @param _owner the future owner of the created robots. Default to contract Owner
    function createPromorobot(string _name, uint256 _genes, address _owner) external onlyOwner {
        address robotOwner = _owner;
        if (robotOwner == address(0)) {
            robotOwner = owner;
        }
        require(promoCreatedCount < PROMO_CREATION_LIMIT);

        promoCreatedCount++;
        _createRobot(_name, _genes, robotOwner);
    }

    /// @dev Creates a new gen0 robot with the given genes and
    ///  creates an auction for it.
    function createGen0Auction(string _name, uint256 _genes) external onlyOwner {
        require(gen0CreatedCount < GEN0_CREATION_LIMIT);

        uint256 robotId =  _createRobot(_name, _genes, address(this));
        approve(saleAuction, robotId);

        saleAuction.createAuction(
            robotId,
            _computeNextGen0Price(),
            0,
            GEN0_AUCTION_DURATION,
            address(this)
        );

        gen0CreatedCount++;
    }

    /// @dev Computes the next gen0 auction starting price, given
    ///  the average of the past 5 prices + 50%.
    function _computeNextGen0Price() internal view returns (uint256) {
        uint256 avePrice = saleAuction.averageGen0SalePrice();

        // Sanity check to ensure we don't overflow arithmetic
        require(avePrice == uint256(uint128(avePrice)));

        uint256 nextPrice = avePrice + (avePrice / 2);

        // We never auction for less than starting price
        if (nextPrice < GEN0_STARTING_PRICE) {
            nextPrice = GEN0_STARTING_PRICE;
        }

        return nextPrice;
    }
}
