import { getContractFactory } from "@nomiclabs/hardhat-ethers/types";

const { ethers, upgrades } = require("hardhat");

async function main() {
  // Deploying NFTMarket
//   const NFTMarket = await ethers.getContractFactory("NFTMarket");
//   const instanceNFTMarket = await upgrades.deployProxy(NFTMarket);
//   await instanceNFTMarket.deployed();
//   console.log("NFT MARKET PROXY", instanceNFTMarket.address);

  // Deploying Rune
//   const Rune = await ethers.getContractFactory("Rune");
//   const instanceRune = await upgrades.deployProxy(Rune, [instanceNFTMarket.address]);
//   await instanceRune.deployed();
//   console.log("RUNE PROXY", instanceRune.address);

  const Rune = await ethers.getContractFactory("RuneV2");
  const runeContract = await Rune.attach("0x6101ca03aAcd7Fb88ed4E36E366268638BE3F25c")
  
  //CREATE NFT
//   const createNFT = await runeContract.createRune("https://ipfs.infura.io/ipfs/QmXhGDScpoAZopfh4hoDW2qfSAajnVbchsYSUXtm2Z6dEz",5,5)
//   const createNFTtx = await createNFT.wait()

  const number = await runeContract.ownerOf(3)
  console.log("NUMBER", number);
  

  // Upgrading
//   const RuneV2 = await ethers.getContractFactory("RuneV2");
//   const upgradedRune = await upgrades.upgradeProxy("0x6101ca03aAcd7Fb88ed4E36E366268638BE3F25c", RuneV2);
//   console.log("RUNE UPDATED", upgradedRune.address);
  
  
}
main();
