 module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    development: {
      host: "10.100.10.192",
      port: 8545,
      network_id: "*", // Match any network id
      from:"0x6be7ca76ea9018d4dd7746ecbe5fd89c2d7ff2da",
      gas: 4700036
    }
  }
};
