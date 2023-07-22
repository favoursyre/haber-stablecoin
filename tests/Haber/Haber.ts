//This script contains the test for the Haber.sol

//Libraries -->
import { expect } from "chai";
import { ethers } from "hardhat";
import {Ether, FacetCutAction, UpdateAction, IFacetCut} from "./utils";
import {
  abi as abiFacet,
} from "../../artifacts/contracts/Haber/Facets/Config/SettingFacet.sol/SettingFacet.json";
import 'dotenv/config'

//Commencing the test
describe("Haber", () => {
    let HaberContract: ethers.ContractFactory,
    haber: ethers.Contract,
    signer1: ethers.Signer,
    signer2: ethers.Signer,
    signer3: ethers.Signer,
    signer4: ethers.Signer,
    signer5: ethers.Signer
     
     before(async () => {
      [signer1, signer2, signer3, signer4, signer5] = await ethers.getSigners();
      HaberContract = await ethers.getContractFactory("Haber");
      haber = await HaberContract.deploy();
      await haber.deployed();
    });

    //This handles the test for the access control of the smart contract
  describe("\nAccess Control", () => {
    let nominee: any,
    initialOwner: any

    it("should set owner", async () => {
      expect(await haber.owner()).to.equal(signer1.address);
    });

    it("should transfer ownership of the contract", async () => {
      initialOwner = await haber.owner();
      expect(await haber.transferOwnership(signer2.address))
        .to.emit(haber, "OwnershipTransferred")
        .withArgs(initialOwner, signer2.address);
    });

    it("should set the nominee owner", async () => {
      nominee = await haber.nomineeOwner();
      expect(signer2.address).to.equal(nominee);
    })

    it("should allow the nominee owner to accept ownership", async () => {
      await haber.connect(signer2).acceptOwnership();
        expect(await haber.owner()).to.equal(signer2.address);
    })
  });

  //This handles the test for the diamond cut of the smart contract
  describe("\nDiamond Cut", () => {
    let FacetContract: ethers.ContractFactory,
      facet: ethers.Contract,
      facetCuts: IFacetCut[],
      _abiFacet: Ether,
      facetFuncs: string[],
      action: number,
      selectors: string[],
      target: string,
      _callData: string,
      _args: [] | any[]

      before(async () => {
        FacetContract = await ethers.getContractFactory("SettingFacet");
        facet = await FacetContract.deploy();
        await facet.deployed();
        target = facet.address;
        _abiFacet = new Ether(abiFacet);
        facetFuncs = Object.keys(facet.interface.functions);
        selectors = [
          _abiFacet.getFuncSelector(facetFuncs[0]),
          _abiFacet.getFuncSelector(facetFuncs[1]),
          _abiFacet.getFuncSelector(facetFuncs[2]),
        ];
        action = FacetCutAction.Add;
        facetCuts = [
          {
            target,
            action,
            selectors,
          },
        ];
        _args = [
          "0xCbe1fFDfbc50b5fE439D097b32F67cb57111cd86", // address _centralBank,
          "0x76d03D26376020A6Eff5809F4c6531157Eb54428", // address _foundationWallet,
          ethers.BigNumber.from("100000"), // uint256 _thresholdAmount,
          ethers.BigNumber.from("0.9"), // uint64 _transferFeePercent,
          ethers.BigNumber.from("0.5"), // uint64 _centralBankPercent,
          ethers.BigNumber.from("0.2"), // uint64 _minerPercent,
          ethers.BigNumber.from("0.2"), // uint64 _foundationPercent,
          ethers.BigNumber.from("1.5"), // uint128 _collateralPercent,
          ethers.BigNumber.from("1.1"), // uint128 _liquidationPercent
          ethers.BigNumber.from("0.0014") // uint128 _interestRatePercent
        ]
        _callData = _abiFacet.getFuncCallData(facetFuncs[0], _args);
      });

      it("should allow only owner to access the diamondCut function", async () => {
        // let addFacet = await _diamond.connect(signer2).diamondCut(
        //     facetCuts,
        //     _diamond.address,
        //     _callData,
        //     { gasLimit: 800000 }
        //   );
        //   await addFacet.wait();
        console.log("Facet: ", facet);
        //console.log("Call: ", _callData);
      });
  })
});