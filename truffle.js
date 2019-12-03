require('dotenv').config()
const HDWalletProvider = require('truffle-hdwallet-provider')

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    // truffle develop
    development: {
      host: '127.0.0.1',
      port: 9545,
      network_id: '*', // Match any network id
    },
    // ganache-cli
    ganacheCLI: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*',
    },
    // Ganache UI
    ganacheUI: {
      host: '127.0.0.1',
      port: 7545,
      network_id: '*',
    },
    mainnet: {
      provider: function() {
        return new HDWalletProvider(
          process.env.MNEMONIC,
          'https://mainnet.infura.io/zBMpIsDifWp7O3UBi4wV',
          parseInt(process.env.ACCOUNT_INDEX) || 0
        )
      },
      network_id: 1,
      gas: 4600000, // gas limit used for deploying to mainnet, may need to increase this
      gasPrice: 20000000000, // 20 gwei, check gas prices/network congestion before deploying!!!
    },
    rinkebyInfura: {
      provider: function() {
        return new HDWalletProvider(
          process.env.MNEMONIC,
          'https://rinkeby.infura.io/EugbutvwA1nkwH1gYK1k',
          parseInt(process.env.ACCOUNT_INDEX) || 1
        )
      },
      network_id: 4,
      // remove these if they cause issues:
      gas: 6612388, // Gas limit used for deploys
      gasPrice: 20000000000, // 20 gwei
    },
    ropstenInfura: {
      provider: function() {
        return new HDWalletProvider(
          process.env.MNEMONIC,
          'https://ropsten.infura.io/EugbutvwA1nkwH1gYK1k',
          parseInt(process.env.ACCOUNT_INDEX) || 0
        )
      },
      network_id: 3,
      gas: 4600000, // Gas limit used for deploys
      gasPrice: 20000000000, // 20 gwei
    },
  },
  // be careful with this. see here: https://github.com/trufflesuite/truffle-compile/pull/5
  solc: {
    optimizer: {
      enabled: true,
      runs: 200,
    },
  },
  // uncomment this to use gas reporter (slows down tests a tonne)
  // mocha: {
  //   reporter: 'eth-gas-reporter',
  //   reporterOptions : {
  //     currency: 'USD',
  //     gasPrice: 10,
  //   },
  // },
  coverage: {
    host: 'localhost',
    network_id: '*',
    port: 8555, // <-- If you change this, also set the port option in .solcover.js.
    gas: 0xfffffffffff, // <-- Use this high gas value
    gasPrice: 0x01, // <-- Use this low gas price
  },
}
