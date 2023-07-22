/// Facet Initialization Status

//SPDX-FileCopyrightText: © 2023 Ndubuisi Favour <favourndubuisi.official@gmail.com>
//SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.17;

///Libraries -->

/**
 * @title Facet Initialization Storage Smart Contract Library
 * @notice This library helps keep track of facets that has been initialized
 * @dev This library is also imported and utilized both in solidstatediamond's DiamondWritable and DiamondReadable contracts
 */
library FacetInitializeStorage {
    /**
     * @notice This is the layout storage struct
     * @param isInitialized This maps facet address to initialized status
     */
    struct Layout {
        mapping(address => bool) isInitialized;
    }

    bytes32 internal constant FACET_INIT_SLOT =
        keccak256("lib.storage.FacetInitialize");

    /**
     * @notice This sets the layout of the facet struct
     * @return l Layout struct of FacetInitializeStorage
     */
    function layout() internal pure returns (Layout storage l) {
        bytes32 _slot = FACET_INIT_SLOT;
        assembly {
            l.slot := _slot
        }
    }

    /**
     * @notice This gets the init status of a given facet address
     * @param _facetAddress Address of facet to be queried
     * @return bool Initialization status of the facet
     */
    function getFacetInitStatus(
        address _facetAddress
    ) internal view returns (bool) {
        return layout().isInitialized[_facetAddress];
    }

    /**
     * @notice This sets the init status of a given facet
     * @param _facetAddress Address of facet that has been initialized
     */
    function setFacetInitStatus(address _facetAddress) internal {
        layout().isInitialized[_facetAddress] = true;
    }
}
