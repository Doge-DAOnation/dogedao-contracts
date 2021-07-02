/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require('dotenv').config()
require('@nomiclabs/hardhat-ethers');

module.exports = {
  solidity: "0.8.4",

  networks: {
    ropsten: {
      url: `https://eth-ropsten.alchemyapi.io/v2/nuCQDs_kpXm1v3ySaD5tXB7EofGKTqPb`,
      accounts: [`0x${process.env.PRIVATE_KEY}`]
    }
  },

  etherscan: {
    apiKey: process.env.ETHER_SCAN_API_KEY
  }
};
