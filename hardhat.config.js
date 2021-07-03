/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require('dotenv').config()
require('@nomiclabs/hardhat-ethers');

module.exports = {
  solidity: "0.8.4",

  networks: {
    ropsten: {
      url: `https://eth-ropsten.alchemyapi.io/v2/iA8QtJx-i_49kMV8xnVc9SXR6krfjNPS`,
      accounts: [`0x${process.env.PRIVATE_KEY}`]
    }
  },

  etherscan: {
    apiKey: process.env.ETHER_SCAN_API_KEY
  }
};
