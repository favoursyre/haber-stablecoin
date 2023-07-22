/// Haber Diamond Smart Contract

//SPDX-FileCopyrightText: © 2023 Ndubuisi Favour <favourndubuisi.official@gmail.com>
//SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.17;

///Libraries -->
import "@solidstate/contracts/proxy/diamond/SolidStateDiamond.sol";
import "hardhat/console.sol";
import {FacetInitializeStorage} from "../Libraries/FacetInit.sol";

/**
 * @title Haber Diamond smart contract
 */
contract Haber is SolidStateDiamond {
    //This event emits whenever a facet with an initialize function has been initialized
    event FacetInitialized(address indexed _facetAddress);

    /**
     * @notice update functions callable on Diamond proxy
     * @param facetCuts array of structured Diamond facet update data
     * @param target optional recipient of initialization delegatecall
     * @param data optional initialization call data
     */
    function _diamondCut(
        FacetCut[] memory facetCuts,
        address target,
        bytes memory data
    ) internal override returns (bool) {
        bool _success = super._diamondCut(facetCuts, target, data);
        if (_success) {
            if (data.length != 0) {
                FacetInitializeStorage.setFacetInitStatus(facetCuts[0].target);
                emit FacetInitialized(facetCuts[0].target);
            }
        }
        console.log("Sucess: ", _success);
        return _success;
    }

    /**
     * @notice This gets the initialized status of a given facet address
     * @param _facetAddress address of the facet
     * @return _initStat initialized status of the facet
     */
    function initializedFacets(
        address _facetAddress
    ) external view returns (bool) {
        return FacetInitializeStorage.getFacetInitStatus(_facetAddress);
    }
}
