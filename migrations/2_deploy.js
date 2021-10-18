const TopGoalNft = artifacts.require('TOPGOALNFT');

const admin = '0x14E0a3e6e8E24e5c0B2873a786e55d571B9F0eE9'

const baseUri = 'https://topgoal.io/api/meta/'
const name = 'TopGoal Card NFT'
const symbol = 'TOPGOAL'

module.exports = async function (deployer) {
  await deployer.deploy(TopGoalNft, admin, baseUri, name, symbol);
};
