import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import { readEnvOrThrow } from './scripts/utils';

const SK = readEnvOrThrow("SK");
const accounts: string[] = [SK];

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    aurora: {
      accounts,
      chainId: 0x4e454152, // 1313161554
      gas: "auto",
      gasMultiplier: 1,
      gasPrice: "auto",
      timeout: 40000,
      url: "https://mainnet.aurora.dev",
    },
    bsc: {
      accounts,
      chainId: 0x38, //56
      gas: "auto",
      gasMultiplier: 1,
      gasPrice: "auto",
      timeout: 40000,
      url: "https://bsc.publicnode.com",
    },
    moonbeam: {
      accounts,
      chainId: 0x504, // 1284
      gas: "auto",
      gasMultiplier: 1,
      gasPrice: "auto",
      timeout: 40000,
      url: "https://moonbeam.public.blastapi.io",
    },
    polygon: {
      accounts,
      chainId: 0x89, // 137
      gas: "auto",
      gasMultiplier: 1,
      gasPrice: "auto",
      timeout: 40000,
      url: "https://polygon.llamarpc.com",
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  }
};

export default config;
