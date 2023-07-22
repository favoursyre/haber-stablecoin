//Setting up the hardhat config file

//Libraries -->
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-gas-reporter";
import "dotenv/config";

//This contains all the configurations for hardhat
const config: HardhatUserConfig = {
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    outputFile: "Gas_Fee_Report.txt",
    currency: "USD",
    showTimeSpent: true,
    coinmarketcap: process.env.COIN_MARKETCAP_API_KEY || "",
    token: "ETH",
  },
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  defaultNetwork: "ganache",
  networks: {
    ganache: {
      url: process.env.GANACHE_URL,
      accounts: [
        process.env.PRIVATE_KEY_GA1 || "", 
        process.env.PRIVATE_KEY_GA2 || "", 
        process.env.PRIVATE_KEY_GA3 || "", 
        process.env.PRIVATE_KEY_GA4 || "", 
        process.env.PRIVATE_KEY_GA5 || ""
    ],
    },
    goerli: {
      url: process.env.GOERLI_URL,
      accounts: [process.env.PRIVATE_KEY_GO1 || ""],
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./tests",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  //   ignoreFiles: ["./contracts/Haber/Blacklist.sol", "./contracts/Haber/ExchangeRate.sol", "./contracts/Haber/Governance.sol",
  //   "./contracts/Haber/Security.sol", "./contracts/Haber/Settings.sol", "./contracts/Haber/Transaction.sol"
  // ],
};

export default config;
