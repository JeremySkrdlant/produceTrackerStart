import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  paths: {
    "artifacts": "../frontend/src/Artifacts"
  },
  solidity: "0.8.19",
};

export default config;
