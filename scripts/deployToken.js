const hre = require("hardhat");

async function main() {
  const EcoCycle = await hre.ethers.getContractFactory("EcoCycle");
  const token = await EcoCycle.deploy(1000000000);
  await token.deployed();
  console.log("Token address ", token.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
