import * as dotenv from "dotenv";

import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-ethers";
import "@openzeppelin/hardhat-upgrades";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";

dotenv.config();
const KEY = process.env.PRIVATE_KEY
const URL = process.env.URL
// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

const config: HardhatUserConfig = {
  solidity: "0.8.4",
  defaultNetwork: "mumbai",
  networks: {
    mumbai: {
      url: "https://speedy-nodes-nyc.moralis.io/d7e06cd98ab031958d2d3943/polygon/mumbai",
      accounts:["c503799785ba5947b5712f47b4c01852e2d2232ba647b444eff073dfdd797de4"]
    }
  },
  etherscan: {
    apiKey: "UV74JUZQVJT67FMGWPJ5SUQ5MXMNZP37SA",
 }
};

export default config;
