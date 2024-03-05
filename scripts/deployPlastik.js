const hre = require('hardhat');

async function main() {
  const plastik = await hre.ethers.deployContract('Plastik');
  await plastik.waitForDeployment();
  console.log(`Plastik contract deployed to ${plastik.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});