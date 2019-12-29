/* globals artifacts */
const ParaswapParams = artifacts.require('./ParaswapParams.sol')
const SmartFundRegistry = artifacts.require('./SmartFundRegistry.sol')
const ExchangePortal = artifacts.require('./ExchangePortal.sol')
const PermittedExchanges = artifacts.require('./PermittedExchanges.sol')

const PARASWAP_NETWORK_ADDRESS = ""
const PARASWAP_PRICE_ADDRESS = ""
const PRICE_FEED_ADDRESS = ""
const PLATFORM_FEE = 1000

module.exports = (deployer, network, accounts) => {
  deployer
    .then(() => deployer.deploy(ParaswapParams))
    .then(() => deployer.deploy(ExchangePortal, PARASWAP_NETWORK_ADDRESS, PRICE_FEED_ADDRESS, ParaswapParams.address))
    .then(() => deployer.deploy(PermittedExchanges, ExchangePortal.address))
    .then(() =>
      deployer.deploy(
        SmartFundRegistry,
        PLATFORM_FEE,
        ExchangePortal.address,
        PermittedExchanges.address,
      )
    )
}
