// const { ethers, upgrades } = require("hardhat");

async function upgradeProxy(){
    const orbV2 = ethers.getContractFactory("ORBv2")
    const orbV2Proxy = await upgrades.upgradeProxy("0x20e8994a117B5b04414d3eAe49f7Dd98526c4ecb", orbV2)
    console.log("NEW PROXY", orbV2Proxy.address)
}


upgradeProxy()
  
