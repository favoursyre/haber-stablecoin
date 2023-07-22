/// Pausable Storage

//SPDX-FileCopyrightText: © 2023 Ndubuisi Favour <favourndubuisi.official@gmail.com>
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

///Libraries -->
import {FacetModifier} from "./FacetModifier.sol";

/**
 * @title Pausable Storage Smart Contract Library
 * @notice This library handles the pausable storage
 */
library PausableStorage {
    /**
     * @notice This is layout struct
     * @param paused This is the pause state
     */
    struct Layout {
        bool paused;
    }

    bytes32 internal constant STORAGE_SLOT = keccak256("lib.storage.Pausable");

    /**
     * @notice This sets the layout of the facet struct
     * @return l Layout struct of PausableStorage
     */
    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }

    /**
     * @notice This sets the pause value to true
     */
    function pause() internal {
        FacetModifier.__whenNotPaused();

        layout().paused = true;
    }

    /**
     * @notice This sets the pause value to false
     */
    function unPause() internal {
        FacetModifier.__whenPaused();

        layout().paused = false;
    }

    /**
     * @notice This gets the status of pause
     * @return bool The pause status
     */
    function getPause() internal view returns (bool) {
        return layout().paused;
    }
}
