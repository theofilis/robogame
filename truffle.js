const HDWalletProvider = require("truffle-hdwallet-provider");
const mnemonic = "dinner filter frozen verify mix alone mountain onion leisure physical tennis shuffle";

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    // ropsten: {
    //   provider: new HDWalletProvider(mnemonic, "https://ropsten.infura.io/"),
    //   network_id: 3,
    //   gas: 4500000
    // },
    // rinkeby: {
    //   provider: new HDWalletProvider(mnemonic, "https://rinkeby.infura.io"),
    //   network_id: 4,
    //   gas: 4500000
    // },
    // kovan: {
    //   provider: new HDWalletProvider(mnemonic, "https://kovan.infura.io"),
    //   network_id: 42,
    //   gas: 4500000
    // }
  }
};
