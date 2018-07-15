const RobotMinting = artifacts.require("./robot/RobotMinting.sol");

contract("RobotMinting", (accounts) => {
  let instance = null;

  it("Retrieve RobotMinting", async () => {
    instance = await RobotMinting.deployed();
    assert(instance != null, 'valid factory creation');
  });

  it("Create random robot", async () => {
    let result = await instance.createRandomRobot("Terminator");
    assert.equal('0x01', result.receipt.status, '');
  });

  it("Create random robot", async () => {
    let result = await instance.robots(0);
    assert.equal('Terminator', result[0], 'get name');
    assert.equal('3792427804745300', result[1].toString(), 'get dna');
    assert.equal(1, result[2].toNumber(), 'get level');
    assert.equal(result[3].toNumber() > 0, true, 'get readyTime');
    assert.equal(0, result[4], 'get winCount');
    assert.equal(0, result[5], 'get lossCount');
  });

  it("Get owner robot", async () => {
    let result = await instance.robotToOwner(0);
    assert.equal(accounts[0], result, 'get name');
  });

  it("Create random robot (only one per account)", async () => {
    try {
      let result = await instance.createRandomRobot("Terminator");
      assert(false);
    } catch(e) {
      assert(true);
    }
  });

  it("Create random robot (from other user)", async () => {
    let result = await instance.createRandomRobot("Terminator", {from: accounts[1]});
    assert.equal('0x01', result.receipt.status, '');
  });

  it("Level up robot", async () => {
    // Task 2. Upgrade το robot σου.
    const fee = web3.toWei(0.001,"ether");
    let result = await instance.levelUp(0, {from: accounts[2], value: fee});
    assert.equal('0x01', result.receipt.status, '');
    result = await instance.robots(0);
    assert.equal(2, result[2].toNumber(), 'get level');

    result = await instance.levelUp(0, {from: accounts[2], value: fee});
    assert.equal('0x01', result.receipt.status, '');
    result = await instance.robots(0);
    assert.equal(3, result[2].toNumber(), 'get level');
  });

  it("Should withdraw", async () => {
    let result = await instance.withdraw();
    assert.equal('0x01', result.receipt.status, '');
  });

  it("Should not withdraw", async () => {
    try {
      let result = await instance.withdraw({from: accounts[2]});
      assert(false);
    } catch(e) {
      assert(true);
    }
  });

  it("Should setLevelUpFee", async () => {
    let result = await instance.setLevelUpFee(web3.toWei(0.002,"ether"));
    assert.equal('0x01', result.receipt.status, 'valid');
  });

  it("Should not setLevelUpFee", async () => {
    try {
      let result = await instance.setLevelUpFee(web3.toWei(0.002,"ether"), {from: accounts[2]});
      assert(false);
    } catch(e) {
      assert(true);
    }
  });

  it("Create level up robot", async () => {
    let fee = web3.toWei(0.001,"ether");

    try {
      let result = await instance.levelUp(0, {from: accounts[2], value: fee});
      assert(false);
    } catch(e) {
      assert(true);
    }
    result = await instance.robots(0);
    assert.equal(3, result[2].toNumber(), 'get level');

    fee = web3.toWei(0.002,"ether");
    result = await instance.levelUp(0, {from: accounts[2], value: fee});
    assert.equal('0x01', result.receipt.status, '');
    result = await instance.robots(0);
    assert.equal(4, result[2].toNumber(), 'get level');
  });

  it("Create change name robot", async () => {
    let result = await instance.changeName(0, "HAL2000");
    assert.equal('0x01', result.receipt.status, '');
    result = await instance.robots(0);
    assert.equal('HAL2000', result[0], 'get name');

    try {
      let result = await instance.changeName(0, "Invalid", {from: accounts[2]});
      assert(false);
    } catch(e) {
      assert(true);
    }
  });

  it("Change dna robot", async () => {
    let result;
    const fee = web3.toWei(0.002,"ether");
    for (let index = 0; index < 20; index++) {
      result = await instance.levelUp(0, {from: accounts[2], value: fee});
    }

    result = await instance.changeDna(0, 69);
    assert.equal('0x01', result.receipt.status, '');
    result = await instance.robots(0);
    assert.equal(69, result[1].toNumber(), 'get dna');

    try {
      let result = await instance.changeName(0, "Invald", {from: accounts[2]});
      assert(false);
    } catch(e) {
      assert(true);
    }
  });

  it("Get robots by owner", async () => {
    // Task 8. Βρες τα robot του χρήστη,
    let result = await instance.getRobotsByOwner(accounts[0]);
    assert.equal(0, result[0], 'get robots');
  });

  it("Attack robot", async () => {
    await instance.createRandomRobot("T12", {from: accounts[3]});

    let result = await instance.robots(0);
    assert.equal(0, result[4].toNumber() + result[5].toNumber(), 'get win-loss');

    result = await instance.attack(0, 1);
    assert.equal('0x01', result.receipt.status, 'valid');

    result = await instance.robots(0);
    assert.equal(1, result[4].toNumber() + result[5].toNumber(), 'get win-loss');

    result = await instance.robots(1);
    assert.equal(1, result[4].toNumber() + result[5].toNumber(), 'get win-loss');
  });

  it("Get balanceOf", async () => {
    let result = await instance.balanceOf(accounts[0]);
    assert.equal(1, result, 'valid');
  });

  it("Get ownerOf", async () => {
    let result = await instance.ownerOf(0);
    assert.equal(accounts[0], result, 'valid');
  });

  it("Make a transfer", async () => {
    let result = await instance.transfer(accounts[1], 0);
    assert.equal('0x01', result.receipt.status, '');
    result = await instance.ownerOf(0);
    assert.equal(accounts[1], result, 'valid');
  });

  it("Get approve", async () => {
    let result = await instance.approve(accounts[0], 0, {from: accounts[1]});
    assert.equal('0x01', result.receipt.status, '');

    result = await instance.ownerOf(0);
    assert.equal(accounts[1], result, 'valid');

    result = await instance.takeOwnership(0);
    assert.equal('0x01', result.receipt.status, '');

    result = await instance.ownerOf(0);
    assert.equal(accounts[0], result, 'valid');
  });
});

