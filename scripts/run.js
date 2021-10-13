const { hexStripZeros } = require("@ethersproject/bytes")

const main =  async () => {
    // compile the contract --> creates a artifacts folder
    const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
    // HRE: hardhat runtime env 
    // this means that you don't need to import extra files
    // you will get the one in hardhat.config.json 


    // create and deploy to a local env
    const nftContract = await nftContractFactory.deploy();

    // wait until deployed 
    await nftContract.deployed();

    console.log("contract deployed to: ", nftContract.address);
    
    // Call the function.
    let txn = await nftContract.makeAnEpicNFT()

    await txn.wait()
    console.log("Minted NFT #1")  


    txn = await nftContract.makeAnEpicNFT()
    // Wait for it to be mined.
    await txn.wait()
    console.log("Minted NFT #2") 

};

const run = async () => {
    try {
        await main();
        process.exit(0)
    } catch (error){
        console.log(error);
        process.exit(1);
    }
};

run();