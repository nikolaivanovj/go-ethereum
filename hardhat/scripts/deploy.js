const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const Token = await hre.ethers.getContractFactory("Token");
  
  // Attempt to deploy the contract
  try {
    const token = await Token.deploy();

    // Log the token object to inspect its properties
    console.log("Token object:", token);

    // Check if the deployTransaction is available
    if (token.deployTransaction) {
      console.log("Deploy transaction hash:", token.deployTransaction.hash);
      await token.deployTransaction.wait(); // Wait for the deployment transaction to be mined
      console.log("Token deployed to:", token.address);
    } else {
      console.error("Deploy transaction is undefined");
    }
  } catch (error) {
    console.error("Error during contract deployment:", error);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Error in main function:", error);
    process.exit(1);
  });
