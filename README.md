## Sonar Finance Smart Contracts

This repository contains the smart contracts for Sonar Finance. The human-driven predictions market in Worldchain.

## Development

We use hardhat for development. And Uniswap Deployed addresses for permitted transfers using Permit2. ERC20 Implementation is done using `solmate` library. Everything else is using `OpenZeppelin`.

Code is written for Solidity 0.8.20 and above. Code is MIT Licensed so feel free to use it in your own projects. And if possible, please contribute back to the repo or mention us in your project.

---

For local development, first setup a deployer wallet and if you want to also veryify contracts on Etherscan (Or any -scan explorer), you will need to setup the required API keys in a `.env` file.

> [!CAUTION]
> This repo contains code that is updated frequently or might have pieces that are not audited. Use at your own risk.
