/// Blacklist Storage

//SPDX-FileCopyrightText: © 2023 Ndubuisi Favour <favourndubuisi.official@gmail.com>
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

///Libraries -->
import {FacetModifier} from "./FacetModifier.sol";

/**
 * @title Blacklist Storage Smart Contract Library
 * @notice This library helps keep track of users that has been blacklisted
 */
library BlacklistStorage {
    /**
     * @notice This is the layout storage struct
     * @param isBlacklisted This maps user address to blacklist status
     */
    struct Layout {
        mapping(address => bool) isBlacklisted;
    }

    bytes32 internal constant BLACKLIST_SLOT =
        keccak256("lib.storage.account.Blacklist");

    /**
     * @notice This sets the layout of the facet struct
     * @return l Layout struct of BlacklistStorage
     */
    function layout() internal pure returns (Layout storage l) {
        bytes32 _slot = BLACKLIST_SLOT;
        assembly {
            l.slot := _slot
        }
    }

    /**
     * @notice This function gets the blacklist status of a user
     * @param _user Address of user to be queried
     * @return bool Blacklist status of user
     */
    function getBlacklistStatus(address _user) internal view returns (bool) {
        return layout().isBlacklisted[_user];
    }

    /**
     * @notice This function adds a blacklisted user
     * @param _user Address of user to be blacklisted
     */
    function addUser(address _user) internal {
        layout().isBlacklisted[_user] = true;
    }

    /**
     * @notice This function removes a blacklisted user
     * @param _user Address of blacklisted user to be unblacklisted
     */
    function removeUser(address _user) internal {
        FacetModifier.__blacklisted(_user);

        layout().isBlacklisted[_user] = false;
    }
}
