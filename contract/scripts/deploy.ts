import { ethers } from "hardhat";

async function main() {
  const produce = await ethers.deployContract("ProduceTracker");

  await produce.waitForDeployment();

  console.log(
    `contract deployed to -  ${await produce.getAddress()}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
