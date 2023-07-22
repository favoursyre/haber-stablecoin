/// User Verification Status

//SPDX-FileCopyrightText: © 2023 Ndubuisi Favour <favourndubuisi.official@gmail.com>
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

///Libraries -->

/**
 * @title Verification Storage Smart Contract Library
 * @notice This library helps keep track of accounts that has been verified
 */
library VerificationStorage {
    /**
     * @notice This is layout struct
     * @param isVerified This maps facet address to verification status
     */
    struct Layout {
        mapping(address => bool) isVerified;
    }

    bytes32 internal constant VERIFICATION_SLOT =
        keccak256("lib.storage.account.Verification");

    /**
     * @notice This sets the layout of the facet struct
     * @return l Layout struct of VerificationStorage
     */
    function layout() internal pure returns (Layout storage l) {
        bytes32 _slot = VERIFICATION_SLOT;
        assembly {
            l.slot := _slot
        }
    }

    /**
     * @notice This gets the verification status of a user
     * @param _user Address of user to be queried
     * @return bool The pause status
     */
    function getVerifiedStatus(address _user) internal view returns (bool) {
        return layout().isVerified[_user];
    }

    /**
     * @notice This sets the verification status of a user
     * @param _user Address of user to be verified
     */
    function setVerifiedStatus(address _user) internal {
        layout().isVerified[_user] = true;
    }
}
