const { getNamedAccounts, ethers } = require('hardhat');

const main = async () => {
  const { deployer } = await getNamedAccounts();
  const fundMe = await ethers.getContract('FundMe', deployer);

  console.log('Funding Contract...');

  const trxRes = await fundMe.withdraw();
  await trxRes.wait(1);

  console.log('Got it');
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
