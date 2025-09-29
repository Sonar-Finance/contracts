import type { HardhatUserConfig } from "hardhat/config"
import "@nomicfoundation/hardhat-toolbox"
import "dotenv/config"

const argv = require("yargs/yargs")(process.argv.slice(2)).parse()
const NETWORK = argv.network as string

const ETHERSCAN_ETHEREUM_KEY = process.env.ETHERSCAN_ETHEREUM_KEY!
const ETHERSCAN_WORLD_KEY = process.env.ETHERSCAN_WORLD_KEY!
const ETHERSCAN_BASE_KEY = process.env.ETHERSCAN_BASE_KEY!
const DEPLOYER_PK = process.env.DEPLOYER_PK!

const ETHERSCAN_API_KEY =
  {
    baseMainnet: ETHERSCAN_BASE_KEY,
    worldMainnet: ETHERSCAN_WORLD_KEY,
  }[NETWORK] || ETHERSCAN_ETHEREUM_KEY // default to ethereum

console.debug("Network:", NETWORK || "N/A")

const config: HardhatUserConfig = {
  sourcify: {
    enabled: true,
  },
  solidity: {
    version: "0.8.24",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  etherscan: {
    enabled: true,
    apiKey: ETHERSCAN_API_KEY,
    customChains: [
      {
        chainId: 1,
        // eth mainnet
        network: "ethMainnet",
        urls: {
          apiURL: "https://api.etherscan.io/api",
          browserURL: "https://etherscan.io",
        },
      },
      {
        chainId: 480,
        network: "worldMainnet",
        urls: {
          apiURL: "https://api.worldscan.org/api",
          browserURL: "https://worldscan.org/",
        },
      },
      {
        chainId: 43114,
        network: "baseMainnet",
        urls: {
          apiURL: "https://api.basescan.io/api",
          browserURL: "https://basescan.io",
        },
      },
      {
        chainId: 42220,
        network: "celoMainnet",
        urls: {
          apiURL: "https://api.celoscan.io/api",
          browserURL: "https://celoscan.io",
        },
      },
    ],
  },
  networks: {
    worldMainnet: {
      url: "https://worldchain-mainnet.g.alchemy.com/public",
      accounts: [DEPLOYER_PK],
    },
    baseMainnet: {
      url: "https://base-rpc.publicnode.com",
      accounts: [DEPLOYER_PK],
    },
    ethMainnet: {
      url: "https://eth.llamarpc.com",
      accounts: [DEPLOYER_PK],
    },
  },
}

export default config
