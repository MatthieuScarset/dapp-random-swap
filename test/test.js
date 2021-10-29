const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("RandomSwap", function () {
  it("Deployment should assign the total supply of tokens to the owner", async function () {
    const [owner] = await ethers.getSigners();
    const RandomSwap = await ethers.getContractFactory("RandomSwap");
    const rswap = await RandomSwap.deploy();

    const ownerBalance = await rswap.balanceOf(owner.address);
    expect(await rswap.totalSupply()).to.equal(ownerBalance);
  });

  it("Owner should be able to transfer RWSAP tokens", async function () {
    const RandomSwap = await ethers.getContractFactory("RandomSwap");
    const rswap = await RandomSwap.deploy();
    await rswap.deployed();

    const [owner, guy] = await ethers.getSigners();
    await rswap.transfer(guy.address, 50);
    const payeeCash = await rswap.balanceOf(owner.address);
    expect(ethers.utils.formatEther(payeeCash)).to.equal('50.0');

    /*

    // Deposit test.
    // const setGreetingTx = await greeter.setGreeting("Hola, mundo!");

    // wait until the transaction is mined
    // await setGreetingTx.wait();

    // expect(await greeter.greet()).to.equal("Hola, mundo!");
    */
  });


});
