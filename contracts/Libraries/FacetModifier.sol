/// Facet Modifiers

//SPDX-FileCopyrightText: © 2023 Ndubuisi Favour <favourndubuisi.official@gmail.com>
//SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.17;

///Libraries -->
import {FacetInitializeStorage} from "./FacetInit.sol";
import {VerificationStorage} from "./Verification.sol";
import {PausableStorage} from "./Pausable.sol";
import {BlacklistStorage} from "./Blacklist.sol";
import {ERC20Storage} from "../Haber/Facets/ERC20/ERC20Storage.sol";
import {OwnableStorage} from "@solidstate/contracts/access/ownable/OwnableStorage.sol";
import {ERC20BaseStorage} from "@solidstate/contracts/token/ERC20/base/ERC20BaseStorage.sol";

/**
 * @title Facet Modifier Smart Contract Library
 * @notice This library holds facet modifiers
 */
library FacetModifier {
    /// ~~~~~~~~~~~~~~~~ Declaring the necessary errors ~~~~~~~~~~~~~~~~
    /**
     * @notice This reverts whenever there is a double initialization
     * @param _facetAddress Address of the facet that's been initialized more than once
     * @param _error Error message
     */
    error DoubleInitialization(address _facetAddress, string _error);

    /**
     * @notice This reverts whenever there is a zero address
     * @param _address Zero address
     * @param _error Error message
     */
    error ZeroAddress(address _address, string _error);

    /**
     * @notice This reverts whenever x < y is passed in
     * @param _x X value that was passed in
     * @param _y Y value that was passed in
     * @param _error Error message
     */
    error NotGreaterThan(uint256 _x, uint256 _y, string _error);

    /**
     * @notice This reverts whenever an unverified user attempts to make a transaction he is not permitted to
     * @param _user Address of unverified user
     * @param _error Error message
     */
    error NotVerified(address _user, string _error);

    /**
     * @notice This reverts whenever a frozen transaction is trying to be accessed
     * @param _error Error message
     */
    error Pausable__Paused(string _error);

    /**
     * @notice This reverts whenever an unfrozen transaction is trying to be accessed
     * @param _error Error message
     */
    error Pausable__NotPaused(string _error);

    /**
     * @notice This reverts whenever an un-authorized attempt is made on a reserved transaction
     * @param _sender Address of un-authorized user
     * @param _error Error message
     */
    error WrongOwner(address _sender, string _error);

    /**
     * @notice This reverts whenever there's an insufficient balance to carry out a particular transaction
     * @param _amount Amount to be used in the transaction
     * @param _error Error message
     */
    error InsufficientBalance(uint256 _amount, string _error);

    /**
     * @notice This reverts whenever a blacklisted user attempts to make a transaction he isn't permitted to
     * @param _user Address of the blacklisted user
     * @param _error Error message
     */
    error Blacklisted(address _user, string _error);

    /// ~~~~~~~~~~~~~~~~ Declaring the necessary function modifiers ~~~~~~~~~~~~~~~~
    /**
     * @notice This function modifier checks for the init status of a facet
     * @param _facetAddress Address of the facet smart contract
     */
    function __initializeOnce(address _facetAddress) internal view {
        if (FacetInitializeStorage.getFacetInitStatus(_facetAddress))
            revert DoubleInitialization({
                _facetAddress: _facetAddress,
                _error: "Facet already initialized"
            });
    }

    /**
     * @notice This function modifier checks if a given address exist
     * @param _address Given address
     */
    function __onlyRealAddress(address _address) internal pure {
        if (_address == address(0))
            revert ZeroAddress({
                _address: _address,
                _error: "Address doesn't exist"
            });
    }

    /**
     * @notice This function modifier checks if x >= y
     * @param _x X value
     * @param _y Y value
     */
    function __greaterThan(uint256 _x, uint256 _y) internal pure {
        if (_x < _y)
            revert NotGreaterThan({
                _x: _x,
                _y: _y,
                _error: "_x is less than or equal to _y"
            });
    }

    /**
     * @notice This function modifier checks if an address is a contract or account.
     * If size > 0, its a smart contract and vice versa for normal account
     * @param _address Given address
     */
    function __isContract(address _address) internal view returns (bool) {
        uint size;
        assembly {
            size := extcodesize(_address)
        }
        return size > 0;
    }

    /**
     * @notice This function modifier checks for proof of verification
     * @param _user Address of user to be queried
     */
    function __proofOfVerification(address _user) internal view {
        if (!VerificationStorage.getVerifiedStatus(_user))
            revert NotVerified({_user: _user, _error: "Verification required"});
    }

    /**
     * @notice This function modifier checks when its not paused
     */
    function __whenNotPaused() internal view {
        if (PausableStorage.getPause())
            revert Pausable__Paused({_error: "Paused transaction"});
    }

    /**
     * @notice This function modifier checks when its paused
     */
    function __whenPaused() internal view {
        if (!PausableStorage.getPause())
            revert Pausable__NotPaused({_error: "Unpaused transaction"});
    }

    /**
     * @notice This function modifier checks if the caller is the owner
     */
    function __onlyOwner() internal view {
        if (OwnableStorage.layout().owner != msg.sender)
            revert WrongOwner({_sender: msg.sender, _error: "Access denied"});
    }

    /**
     * @notice This function modifier checks if the caller is the owner of deployed contract or account
     */
    function __onlyOwners(address _accountOwner) internal view {
        if (
            OwnableStorage.layout().owner != msg.sender ||
            _accountOwner != msg.sender
        ) revert WrongOwner({_sender: msg.sender, _error: "Access denied"});
    }

    /**
     * @notice This function modifier checks for proof of balance of a certain amount
     * @param _user Address of user to be queried
     * @param _amount Amount to be queried
     */
    function __proofOfBalance(address _user, uint256 _amount) internal view {
        if (ERC20BaseStorage.layout().balances[_user] < _amount)
            revert InsufficientBalance({
                _amount: _amount,
                _error: "Insufficient funds"
            });
    }

    /**
     * @notice This function modifier checks of verification status of users making larger transfers than the threshold amount
     * @param _user Address of user to be queried
     * @param _amount Amount to be queried
     */
    function __verifyTransfer(address _user, uint256 _amount) internal view {
        if (_amount >= ERC20Storage.getThresholdAmount()) {
            __proofOfVerification(_user);
        }
    }

    /**
     * @notice This function modifier checks if a user is blacklisted
     * @param _user Address of user to be queried
     */
    function __nonBlacklisted(address _user) internal view {
        if (BlacklistStorage.getBlacklistStatus(_user))
            revert Blacklisted({_user: _user, _error: "User is blacklisted"});
    }

    /**
     * @notice This function modifier checks if a user isn't blacklisted
     * @param _user Address of user to be queried
     */
    function __blacklisted(address _user) internal view {
        if (!BlacklistStorage.getBlacklistStatus(_user))
            revert Blacklisted({
                _user: _user,
                _error: "User ain't blacklisted"
            });
    }
}
