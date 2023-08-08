import { ethers } from "hardhat";
import { readEnvOrThrow } from './utils';

async function main() {

  const name: string = readEnvOrThrow("NAME");
  const symbol: string = readEnvOrThrow("SYMBOL");
  const bridge: string = readEnvOrThrow("BRIDGE");
  const contractIndex: string = readEnvOrThrow("CONTRACT_INDEX");
  const range: string = readEnvOrThrow("RANGE");
  const baseUri: string = readEnvOrThrow("BASE_URI");
  const wrappedUri: string = readEnvOrThrow("WRAPPED_URI");

  const crossChainNft = await ethers.deployContract("CrossChainNft", [
    name,
    symbol,
    bridge,
    contractIndex,
    range,
    baseUri,
    wrappedUri
  ]);

  await crossChainNft.waitForDeployment();

  console.log(`Deployed to ${crossChainNft.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
