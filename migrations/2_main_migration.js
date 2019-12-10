/* globals artifacts */
const ParaswapParams = artifacts.require('./ParaswapParams.sol')
const SmartFundRegistry = artifacts.require('./SmartFundRegistry.sol')
const ExchangePortal = artifacts.require('./ExchangePortal.sol')
const PermittedExchanges = artifacts.require('./PermittedExchanges.sol')
const PARASWAP_NETWORK_ADDRESS = '0x818E6FECD516Ecc3849DAf6845e3EC868087B755'
const PARASWAP_PRICE_ADDRESS = "0x0e936B11c2e7b601055e58c7E32417187aF4de4a"

const PLATFORM_FEE = 1000

module.exports = (deployer, network, accounts) => {
  deployer
    .then(() => deployer.deploy(ExchangePortal, PARASWAP_NETWORK_ADDRESS, PARASWAP_PRICE_ADDRESS))
    .then(() => deployer.deploy(PermittedExchanges, ExchangePortal.address))
    .then(() => deployer.deploy(ParaswapParams))
    .then(() =>
      deployer.deploy(
        SmartFundRegistry,
        PLATFORM_FEE,
        ExchangePortal.address,
        PermittedExchanges.address,
        ParaswapParams.address
      )
    )
}
