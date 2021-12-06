const { expect } = require("chai")
const hre = require("hardhat")
const { ethers } = require("hardhat")
const { BigNumber } = require("ethers")
const {
	expectRevert
} = require('@openzeppelin/test-helpers');

let NFT;
let nft;
let owner;
let account1;
let reserveAddress;
const testuri = 'testuri';

function generateFakeURLs(amount) {
	let results = [];
	for (let i = 0; i < amount; i++) {
		results.push('https://fake.com/' + i);
	}
	return results;
}

describe("NFT", function () {
	before(async function () {
		let wallets = await ethers.getSigners()
		owner = wallets[0]
		account1 = wallets[1]
		reserveAddress = wallets[2]
		NFT = await ethers.getContractFactory('NFT')
	});
	beforeEach(async () => {
		nft = await NFT.deploy();
	})
})