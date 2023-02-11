require('@nomiclabs/hardhat-ethers');
const hre = require('hardhat')

const proxyType = {kind : "uups"};

const ManagerContractBuildName = "ManagerContract"

const decimals = 10 **18;

async function main() {
    const[deployer] = await hre.ethers.getSigners();

    console.log("======================\n\r");
    console.log("Deploy contract with the account: ", deployer.address);
    console.log("Account balance: ", ((await deployer.getBalance()) / decimals).toString());
    console.log("======================\n\r");

    const ManagerContractFactory = await hre.ethers.getContractFactory(ManagerContractBuildName);
    const ManagerContractArtifact = await hre.artifacts.readArtifact(ManagerContractBuildName);
    const ManagerContract = await hre.upgrades.deployProxy(ManagerContractFactory, proxyType);

    await ManagerContract.deployed();

    console.log(`Manager contract address :  ${ManagerContract.address}`);
    implementationAddress = await hre.upgrades.erc1967.getImplementationAddress(ManagerContract.address);
    console.log(`${ManagerContractArtifact.contractName} implementation address: ${implementationAddress}`);

    console.log("=============================\n\r");
    
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1);
    })