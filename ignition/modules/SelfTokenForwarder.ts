import { buildModule } from "@nomicfoundation/hardhat-ignition/modules"

// hh ignition deploy --network worldMainnet ignition/modules/SelfTokenForwarder.ts --verify

const PERMIT2_CONTRACT = "0x000000000022D473030F116dDEE9F6B43aC78BA3"
const ADDRESS_WLD = "0x2cFc85d8E48F8EAB294be644d9E25C3030863003"
const SelfTokenForwarder = buildModule("SelfTokenForwarder", (m) => {
  const contract = m.contract("SelfTokenForwarder", [
    PERMIT2_CONTRACT,
    ADDRESS_WLD,
  ])
  return { contract }
})

export default SelfTokenForwarder
