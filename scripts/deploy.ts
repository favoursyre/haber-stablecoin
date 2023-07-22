//This is the deploy script

//Libraries -->
import { ethers, waffle } from "hardhat";

//Commencing the code
async function Haber() {
  let HaberContract: any,
  haber: any,
  provider: any,
  owner: any,
  signer1: any,
  signer2: any
  
  [owner, signer1, signer2] = await ethers.getSigners();
  HaberContract = await ethers.getContractFactory("Haber", owner);
  haber = await HaberContract.deploy();
  console.log(
    "Haber contract deployed to ",
    haber.address,
    "by ",
    owner.address
  );
 provider = waffle.provider;
}

async function main() {
  await Haber();
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
