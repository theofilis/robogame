const RobotMinting = artifacts.require("./robot/RobotMinting.sol");
const SaleClockAuction = artifacts.require("./auction/SaleClockAuction.sol");

contract("SaleClockAuction", (accounts) => {
  let instance = null;
  let instanceRobot = null;

  it("Retrieve deployed contract", async () => {
    instance = await SaleClockAuction.deployed();
    instanceRobot = await RobotMinting.deployed();

    assert(instance != null, 'SaleClockAuction contract is deployed');
    assert(instanceRobot != null, 'valid factory creation');
  });

  it("Get averageGen0SalePrice", async () => {
    let price = await instance.averageGen0SalePrice();
    assert(price >= 0, 'price');
  });

  it("Get nonFungibleContract", async () => {
    let token = await instance.nonFungibleContract();
    assert(/0x.*/.exec(token), 'token');
  });

  it("Get ownerCut", async () => {
    let ownerCut = await instance.ownerCut();
    assert(ownerCut == 2000, 'ownerCut');
  });
});
