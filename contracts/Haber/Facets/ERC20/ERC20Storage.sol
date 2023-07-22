/// Haber Token Storage Library

//SPDX-FileCopyrightText: © 2023 Ndubuisi Favour <favourndubuisi.official@gmail.com>
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

///Libraries -->
import {FacetModifier} from "../../../Libraries/FacetModifier.sol";

/**
 * @title ERC20 Facet Storage Smart Contract Library
 */
library ERC20Storage {
    /**
     * @notice This is layout storage struct
     * @dev Pass in the calculated percent values e.g. If you want pass in 0.9%, pass in 0.009 instead
     * @param centralBank Address of Kleinrock central bank
     * @param foundationWallet Address of Good Life Foundation
     * @param thresholdAmount Threshold amount for large transfers, etc.
     * @param exchangeRate Exchange rate of haber stablecoin
     * @param transferFeePercent Percent that will be charged on every transfer made with haber
     * @param centralBankPercent Central Bank's percent of the transfer fee
     * @param minerPercent Miner's percent of the transfer fee
     * @param foundationPercent Good Life Foundation's percent of the transfer fee
     */
    struct Layout {
        address centralBank;
        address foundationWallet;
        uint256 thresholdAmount;
        uint256 exchangeRate;
        uint64 transferFeePercent;
        uint64 centralBankPercent;
        uint64 minerPercent;
        uint64 foundationPercent;
    }

    bytes32 internal constant ERC20_SLOT = keccak256("lib.storage.ERC20");

    /**
     * @notice This sets the layout of the facet struct
     * @return l Layout struct of ERC20Storage
     */
    function layout() internal pure returns (Layout storage l) {
        bytes32 _slot = ERC20_SLOT;
        assembly {
            l.slot := _slot
        }
    }

    // /**
    //  * @notice This gets the Kleinrock central bank address
    //  * @return address Address of Kleinrock central bank
    //  */
    // function getCentralBank() internal view returns (address) {
    //     return layout().centralBank;
    // }

    /**
     * @notice This gets the Kleinrock central bank address and wallet
     * @return _centralBank Address of Kleinrock central bank
     * @return _centralBankPercent Central Bank's percent of transfer fee
     */
    function getCentralBankData()
        internal
        view
        returns (address _centralBank, uint64 _centralBankPercent)
    {
        return (layout().centralBank, layout().centralBankPercent);
    }

    /**
     * @notice This gets Good Life foundation address and wallet
     * @return _foundationWallet Address of Good Life foundation
     * @return _foundationPercent Good Life foundation's percent of transfer fee
     */
    function getFoundationData()
        internal
        view
        returns (address _foundationWallet, uint64 _foundationPercent)
    {
        return (layout().foundationWallet, layout().foundationPercent);
    }

    /**
     * @notice This gets the threshold amount
     * @return uint256 The threshold amount for verification, etc.
     */
    function getThresholdAmount() internal view returns (uint256) {
        return layout().thresholdAmount;
    }

    /**
     * @notice This gets the exchange rate of Haber token
     * @return uint64 The exchange rate for Haber token
     */
    function getExchangeRate() internal view returns (uint256) {
        return layout().exchangeRate;
    }

    /**
     * @notice This gets the amount of transfer fee with respect to the amount to be transfered
     * @param _amount Amount of token
     * @return uint256 Transfer fee amount
     */
    function getTransferFee(uint256 _amount) internal view returns (uint256) {
        return (layout().transferFeePercent * _amount);
    }

    /**
     * @notice This gets the owner share of the transfer fee with respect to the owner's percent
     * @param _amount Amount of token
     * @return uint256 Amount of owner's share of transfer fee
     */
    function getCentralBankShare(
        uint256 _amount
    ) internal view returns (uint256) {
        return (layout().centralBankPercent * _amount);
    }

    /**
     * @notice This gets the miner share of the transfer with respect to the miner's percent
     * @param _amount Amount of token
     * @return uint256 Amount of miner's share of transfer fee
     */
    function getMinerShare(uint256 _amount) internal view returns (uint256) {
        return (layout().minerPercent * _amount);
    }

    /**
     * @notice This gets the foundation's share of the transfer with respect to the foundation's percent
     * @param _amount Amount of token
     * @return uint256 Amount of foundation's share of transfer fee
     */
    function getFoundationShare(
        uint256 _amount
    ) internal view returns (uint256) {
        return (layout().foundationPercent * _amount);
    }

    //function getAllShare(uint256 _amount) internal view returns ()

    // /**
    //  * @notice This gets the transfer fee percent
    //  * @return uint64 Transfer fee percent
    //  */
    // function getTransferFeePercent() internal view returns (uint64) {
    //     return layout().transferFeePercent;
    // }

    // /**
    //  * @notice This gets the owner percent
    //  * @return uint64 Owner percent of transfer fee
    //  */
    // function getOwnerPercent() internal view returns (uint64) {
    //     return layout().ownerPercent;
    // }

    // /**
    //  * @notice This gets the miner percent
    //  * @return uint64 Miner percent of transfer fee
    //  */
    // function getMinerPercent() internal view returns (uint64) {
    //     return layout().minerPercent;
    // }

    // /**
    //  * @notice This gets the foundation percent
    //  * @return uint64 Foundation percent of transfer fee
    //  */
    // function getFoundationPercent() internal view returns (uint64) {
    //     return layout().foundationPercent;
    // }

    /**
     * @notice This gets the all percent variables in the storage
     * @return _transferFeePercent Transfer fee percent
     * @return _centralBankPercent Central bank percent of transfer fee
     * @return _minerPercent Miner percent of transfer fee
     * @return _foundationPercent Foundation percent of transfer fee
     */
    function getAllPercent()
        internal
        view
        returns (
            uint64 _transferFeePercent,
            uint64 _centralBankPercent,
            uint64 _minerPercent,
            uint64 _foundationPercent
        )
    {
        return (
            layout().transferFeePercent,
            layout().centralBankPercent,
            layout().minerPercent,
            layout().foundationPercent
        );
    }

    /**
     * @notice This sets the kleinrock central bank address
     * @param _address Address of kleinrock central bank
     */
    function setCentralBank(address _address) internal {
        layout().centralBank = _address;
    }

    /**
     * @notice This sets the foundation wallet address
     * @param _address Address of foundation wallet
     */
    function setFoundationWallet(address _address) internal {
        layout().foundationWallet = _address;
    }

    /**
     * @notice This sets the threshold amount
     * @param _amount Threshold amount
     */
    function setThreshold(uint256 _amount) internal {
        layout().thresholdAmount = _amount;
    }

    /**
     * @notice This sets the exchange rate of the Haber token
     * @param _exchangeRate Exchange rate amount
     */
    function setExchangeRate(uint256 _exchangeRate) internal {
        layout().exchangeRate = _exchangeRate;
    }

    // /**
    //  * @notice This sets the transfer fee percent
    //  * @param _transferFeePercent Transfer fee percent
    //  */
    // function setTransferFeePercent(uint64 _transferFeePercent) internal {
    //     layout().transferFeePercent = _transferFeePercent / 100;
    // }

    /**
     * @notice This function sets the transfer fee, central bank, miner and foundation's percent
     * @dev Pass in the calculated percent values e.g. If you want pass in 0.9%, pass in 0.009 instead
     * @param _transferFeePercent Transfer fee percent
     * @param _centralBankPercent Central bank percent
     * @param _foundationPercent Foundation's percent of Central's bank's percent
     */
    function setAllPercent(
        uint64 _transferFeePercent,
        uint64 _centralBankPercent,
        uint64 _minerPercent,
        uint64 _foundationPercent
    ) internal {
        FacetModifier.__greaterThan(
            _transferFeePercent,
            (_centralBankPercent + _minerPercent + _foundationPercent)
        );

        layout().transferFeePercent = _transferFeePercent;
        layout().centralBankPercent = _foundationPercent;
        layout().minerPercent = _minerPercent;
        layout().foundationPercent = _foundationPercent;
    }
}
