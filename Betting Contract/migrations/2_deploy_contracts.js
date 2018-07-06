var Betting = artifacts.require("./Betting.sol");

module.exports = function(deployer) {
  deployer.deploy(Betting, [123, 456, 789]);
};
