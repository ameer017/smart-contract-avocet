const hre = require('hardhat');

async function main() {
  const avocoin = await hre.ethers.deployContract('AvocoinToken');
  await avocoin.waitForDeployment();
  console.log(`Avocoin contract deployed to ${avocoin.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});