const hre = require("hardhat");

async function main() {

    const [owner] = await ethers.getSigners()
    const Aggregator = await hre.ethers.getContractFactory("Aggregator");
    const aggregator = await Aggregator.connect(owner).deploy();

    await aggregator.deployed();

    console.log(
      `deployed to: ${aggregator.address}`
    );
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
