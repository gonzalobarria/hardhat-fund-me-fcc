require('@nomicfoundation/hardhat-toolbox');
require('hardhat-deploy');
require('dotenv').config();

const RINKEBY_RPC_URL = process.env.RINKEBY_RPC_URL || 'https://rinkeby.net';
const PRIVATE_KEY = process.env.PRIVATE_KEY || 'key';
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || 'key';
const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY || 'key';

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  // solidity: '0.8.9',
  solidity: {
    compilers: [{ version: '0.8.9' }, { version: '0.6.6' }],
  },
  defaultNetwork: 'hardhat',
  networks: {
    rinkeby: {
      url: RINKEBY_RPC_URL,
      accounts: [PRIVATE_KEY],
      chainId: 4,
      blockConfirmations: 6,
    },
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },
  gasReporter: {
    enabled: false,
    outputFile: 'gas-report.txt',
    noColors: true,
    currency: 'USD',
    // coinmarketcap: COINMARKETCAP_API_KEY,
  },
};
