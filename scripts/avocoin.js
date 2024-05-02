const hre = require('hardhat');

async function main() {
  console.log("deployin...")
  const Avocoin = await hre.ethers.deployContract('Avocoin');
  await Avocoin.waitForDeployment();
  console.log(`Contract deployed to ${Avocoin.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
