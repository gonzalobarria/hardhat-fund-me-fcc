const { network } = require('hardhat');
const {
  developmentChains,
  DECIMALS,
  INITIAL_ANSWER,
} = require('../helper-hardhat-config');

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  const { chainId } = network.config;

  if (developmentChains.includes(network.name)) {
    log('Red local detectada, deploying mocks');
    await deploy('MockV3Aggregator', {
      constract: 'MockV3Aggregator',
      from: deployer,
      args: [DECIMALS, INITIAL_ANSWER],
      log: true,
    });
    log('Mock deployed');
    log('---------------------');
  }
};

module.exports.tags = ['all', 'mocks'];
