const { ethers } = require("hardhat");

async function main() {
	const Instance = await ethers.getContractFactory("contract");
	const contract = await Instance.deploy();
	console.log("Box deployed to:", contract.address);
}

main();