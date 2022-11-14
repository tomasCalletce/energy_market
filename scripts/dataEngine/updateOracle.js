const DataPoint = require('./getData.js')
const moment = require('moment')
const hre = require("hardhat");

async function main() {

    const todayMinusFiveDays = moment().subtract(5, 'days').format('YYYY-MM-DD')
    const price = await DataPoint.dataPoint(todayMinusFiveDays)
    const priceParsed = hre.ethers.utils.parseEther(String(price));
    sendDataToContract(priceParsed)
    
}

async function sendDataToContract(price){
    const CONTRACTADDRESS = "0x693Ea3B9fe8D45554d448Ab4B30098F6BE612582"
    const [owner] = await ethers.getSigners()
    const Aggregator = await hre.ethers.getContractFactory("Aggregator");
    const aggregator = Aggregator.attach(CONTRACTADDRESS)
    await aggregator.connect(owner).updateDataPoint(price);
}
  
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
  