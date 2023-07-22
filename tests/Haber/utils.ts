//Utils

//Libraries -->
import { ethers } from "hardhat";

//This class handles Ether
export class Ether {
    iface: any

  constructor(abi: JSON | any) {
    this.iface = new ethers.utils.Interface(abi);
  }

  getFuncSelector(funcName: string): string {
    return this.iface.getSighash(funcName);
  }

  getFuncCallData(funcName: string, args: [] | any[]): string {
    return this.iface.encodeFunctionData(funcName, args);
  }
}

//This handles the deployment of a contract
// export const deployContract = async (contractName: string): Promise<{Contract: any, _contract: any, signers: any[]}> => {
//     const [signer1, signer2, signer3, signer4, signer5] = await ethers.getSigners();
//     const signers = [signer1, signer2, signer3, signer4, signer5]
//     const Contract = await ethers.getContractFactory(contractName);
//     const _contract = await Contract.deploy();
//     await _contract.deployed();
//     return {Contract, _contract, signers}
// }

//This contains interface for FacetCut struct
export interface IFacetCut {
  readonly target: string,
  readonly action: number,
  readonly selectors: string[]
}

//This contains the facet cut actions
interface IFacetCutAction {
    readonly Add: number,
    readonly Replace: number,
    readonly Remove: number,
}

export const FacetCutAction: IFacetCutAction = {
  Add: 0,
  Replace: 1,
  Remove: 2,
};

//This contais the update actions
interface IUpdateAction {
    readonly Add: number,
    readonly Sub: number,
}

export const UpdateAction: IUpdateAction = {
    Add: 0,
    Sub: 1
}