/* globals artifacts */
const ParaswapParams = artifacts.require('./ParaswapParams.sol')
const SmartFundRegistry = artifacts.require('./SmartFundRegistry.sol')
const ExchangePortal = artifacts.require('./ExchangePortal.sol')
const PermittedExchanges = artifacts.require('./PermittedExchanges.sol')
const PriceFeedWrapper = artifacts.require('./PriceFeedWrapper.sol')

const PARASWAP_NETWORK_ADDRESS = "0x72338b82800400f5488eca2b5a37270ba3b7a111"
const PARASWAP_PRICE_ADDRESS = ""

const PLATFORM_FEE = 1000

module.exports = (deployer, network, accounts) => {
  deployer
    .then(() => deployer.deploy(ParaswapParams))
    .then(() => deployer.deploy(PriceFeedWrapper, PARASWAP_PRICE_ADDRESS))
    .then(() => deployer.deploy(ExchangePortal, PARASWAP_NETWORK_ADDRESS, PriceFeedWrapper.address, ParaswapParams.address))
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
