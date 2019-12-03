/* globals artifacts */
const SmartFundRegistry = artifacts.require('./SmartFundRegistry.sol')
const ExchangePortal = artifacts.require('./ExchangePortal.sol')
const PoolPortal = artifacts.require('./PoolPortal.sol')
const PermittedExchanges = artifacts.require('./PermittedExchanges.sol')
const KYBER_NETWORK_ADDRESS = '0x818E6FECD516Ecc3849DAf6845e3EC868087B755'
const BANCOR_NETWORK_ADDRESS = "0x0e936B11c2e7b601055e58c7E32417187aF4de4a"
const BANCOR_ETH_TOKEN = "0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315"
const PLATFORM_FEE = 1000

module.exports = (deployer, network, accounts) => {
  deployer
    .then(() => deployer.deploy(ExchangePortal, KYBER_NETWORK_ADDRESS, BANCOR_NETWORK_ADDRESS, BANCOR_ETH_TOKEN))
    .then(() => deployer.deploy(PermittedExchanges, ExchangePortal.address))
    .then(() => deployer.deploy(PoolPortal))
    .then(() =>
      deployer.deploy(
        SmartFundRegistry,
        PLATFORM_FEE,
        ExchangePortal.address,
        PermittedExchanges.address,
        PoolPortal.address
      )
    )
}
