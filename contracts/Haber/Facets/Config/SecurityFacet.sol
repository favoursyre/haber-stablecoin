/// Security Configurations for Kleinrock Haber Token

//SPDX-FileCopyrightText: © 2023 Ndubuisi Favour <favourndubuisi.official@gmail.com>
//SPDX-License-Identifier: BSD-3-Clause

pragma solidity ^0.8.17;

///Libraries -->
import {FacetModifier} from "../../../Libraries/FacetModifier.sol";
import {PausableStorage} from "../../../Libraries/Pausable.sol";
import {BlacklistStorage} from "../../../Libraries/Blacklist.sol";
import {VerificationStorage} from "../../../Libraries/Verification.sol";
import {ERC20Storage} from "../ERC20/ERC20Storage.sol";
import {ERC20BaseStorage} from "@solidstate/contracts/token/ERC20/base/ERC20BaseStorage.sol";
import {ERC20Facet} from "../ERC20/ERC20Facet.sol";
import {ERC20Storage} from "../ERC20/ERC20Storage.sol";
import "hardhat/console.sol";

/**
 * @title Haber Security Facet smart contract
 */
contract SecurityFacet is ERC20Facet {
    /// ~~~~~~~~~~~~~~~~ Declaring the necessary events for this facet ~~~~~~~~~~~~~~~~
    /**
     * @notice This emits whenever the pause effect has been paused
     * @param _owner Caller of the pause function
     */
    event Paused(address indexed _owner);

    /**
     * @notice This emits whenever the pause effect has been un-paused
     * @param _owner Caller of the pause function
     */
    event Unpaused(address indexed _owner);

    /**
     * @notice This emits whenever a user has been verified
     * @param _user Address of user that was verified
     */
    event UserVerified(address indexed _user);

    /**
     * @notice This emits whenever a user has been blacklisted
     * @param _user Address of user that was blacklisted
     */
    event UserBlacklisted(address indexed _user);

    /**
     * @notice This emits whenever a user has been un-blacklisted
     * @param _user Address of user that was un-blacklisted
     */
    event UserUnBlacklisted(address indexed _user);

    /**
     * @notice This emits whenever the funds of a blacklisted user has been claimed by Kleinrock
     * @param _user Address of blacklisted user
     * @param _amount Amount that was claimed from the blacklisted user's wallet
     */
    event BlacklisteeFundsClaimed(
        address indexed _user,
        address indexed _recipient,
        uint256 indexed _amount
    );

    /// ~~~~~~~~~~~~~~~~ Declaring the necessary functions for this facet ~~~~~~~~~~~~~~~~
    /**
     * @notice This sets the pause value to true
     */
    function pause() external {
        FacetModifier.__onlyOwner();

        PausableStorage.pause();
        emit Paused(msg.sender);
    }

    /**
     * @notice This sets the pause value to false
     */
    function unPause() external {
        FacetModifier.__onlyOwner();

        PausableStorage.unPause();
        emit Unpaused(msg.sender);
    }

    /**
     * @notice This sets the verification status of a user
     * @param _user Address of user to be verified
     */
    function setVerifiedStatus(address _user) external {
        FacetModifier.__onlyOwner();

        VerificationStorage.setVerifiedStatus(_user);
        emit UserVerified(_user);
    }

    /**
     * @notice This adds a user to blacklist
     * @param _user Address of user to be blacklisted
     */
    function addBlacklistee(address _user) external {
        FacetModifier.__onlyOwner();

        BlacklistStorage.addUser(_user);
        emit UserBlacklisted(_user);
    }

    /**
     * @notice This removes a user from blacklist
     * @param _user Address of user to be un-blacklisted
     */
    function removeBlacklistee(address _user) external {
        FacetModifier.__onlyOwner();

        BlacklistStorage.removeUser(_user);
        emit UserUnBlacklisted(_user);
    }

    /**
     * @notice This claims the funds of a blacklisted user
     * @param _user Address of blacklisted user
     * @param _recipient Wallet address that the claimed funds would be moved to
     */
    function claimBlacklisteeFunds(address _user, address _recipient) external {
        FacetModifier.__onlyOwner();
        FacetModifier.__blacklisted(_user);

        (address _centralBank, ) = ERC20Storage.getCentralBankData();
        uint _funds = ERC20BaseStorage.layout().balances[_user];
        burn(_user, _funds);
        if (_recipient == address(0)) {
            _recipient = _centralBank;
        }
        mint(_recipient, _funds);
        emit BlacklisteeFundsClaimed(_user, _recipient, _funds);
    }
}
