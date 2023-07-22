/// Crypto Collateral Facet

//SPDX-FileCopyrightText: © 2023 Ndubuisi Favour <favourndubuisi.official@gmail.com>
//SPDX-License-Identifier: BSD-3-Clause

pragma solidity ^0.8.17;

///Libraries -->
import {FacetModifier} from "../../../Libraries/FacetModifier.sol";
import {ERC20Storage} from "../ERC20/ERC20Storage.sol";
import {CryptoCollateralStorage} from "./CollateralStorage.sol";
import {OwnableStorage} from "@solidstate/contracts/access/ownable/OwnableStorage.sol";
import {Utils} from "../../../Libraries/Utils.sol";
import "hardhat/console.sol";

/**
 * @title Crypto Collateral Facet Smart Contract
 */
contract CryptoCollateralFacet {
    /// ~~~~~~~~~~~~~~~~ Declaring the necessary events for this facet ~~~~~~~~~~~~~~~~
    /**
     * @notice This emits whenever a loan data has been added
     * @param _id ID of the loan data
     * @param _loanTxHash Transaction hash for the loan transfer
     * @param _collateralTxHash Transaction hash for the collateral transfer
     */
    event CryptoCollateralLoanAdded(
        uint indexed _id,
        bytes32 indexed _loanTxHash,
        bytes32 indexed _collateralTxHash
    );

    /**
     * @notice This emits whenever a loan data has been updated
     * @param _id ID of the loan data
     * @param _loanTxHash Transaction hash for the loan transfer
     * @param _collateralTxHash Transaction hash for the collateral transfer
     */
    event CryptoCollateralLoanUpdated(
        uint indexed _id,
        bytes32 indexed _loanTxHash,
        bytes32 indexed _collateralTxHash
    );

    /**
     * @notice This emits whenever a loan data oracle has been updated
     * @param _id ID of the loan data
     * @param _haberOracle Price oracle for haber token
     * @param _cryptoOracle Price oracle for haber token
     */
    event CryptoCollateralLoanOracleUpdated(
        uint indexed _id,
        address indexed _haberOracle,
        address indexed _cryptoOracle
    );

    /**
     * @notice This emits whenever a loan data has been deleted
     * @param _id ID of the loan data
     */
    event CryptoCollateralLoanDeleted(uint _id);

    //This is the init function of this facet
    // function __initCryptoCollateralFacet() external {
    //     FacetModifier.__initializeOnce(address(this));

    // }

    /// ~~~~~~~~~~~~~~~~ Declaring the necessary functions for this facet ~~~~~~~~~~~~~~~~
    /**
     * @notice This function adds new loan data to the collateral storage
     * @param _id ID of the loan data
     * @param _haberOracle Price oracle for Haber
     * @param _loanAmount Loan amount that was requested
     * @param _loanTxHash Transaction hash for the loan transfer
     * @param _cryptoOracle Price oracle for crypto used for the collateral
     * @param _cryptoAmount Amount of the crypto that was used as collateral for the loan
     * @param _collateralTxHash Transaction hash for the collateral transfer
     */
    function addLoanData(
        uint _id,
        address _haberOracle,
        uint _loanAmount,
        bytes32 _loanTxHash,
        address _cryptoOracle,
        uint _cryptoAmount,
        bytes32 _collateralTxHash
    ) external {
        FacetModifier.__onlyOwner();

        CryptoCollateralStorage.addLoanData(
            _id,
            _haberOracle,
            _loanAmount,
            _loanTxHash,
            _cryptoOracle,
            _cryptoAmount,
            _collateralTxHash
        );
        emit CryptoCollateralLoanAdded(_id, _loanTxHash, _collateralTxHash);
    }

    /**
     * @notice This function updates a loan data
     * @param _id ID of the loan data
     * @param _loanAmount Loan amount that was requested
     * @param _loanTxHash Transaction hash for the loan transfer
     * @param _cryptoAmount Amount of the crypto that was used as collateral for the loan
     * @param _collateralTxHash Transaction hash for the collateral transfer
     * @param _updateAction Action to be taken
     */
    function updateLoanData(
        uint _id,
        uint _loanAmount,
        bytes32 _loanTxHash,
        uint _cryptoAmount,
        bytes32 _collateralTxHash,
        CryptoCollateralStorage.UpdateAction _updateAction
    ) external {
        FacetModifier.__onlyOwner();

        CryptoCollateralStorage.updateLoanData(
            _id,
            _loanAmount,
            _loanTxHash,
            _cryptoAmount,
            _collateralTxHash,
            _updateAction
        );
        emit CryptoCollateralLoanUpdated(_id, _loanTxHash, _collateralTxHash);
    }

    /**
     * @notice This function updates the price oracles of a loan data
     * @param _id ID of the loan data
     * @param _haberOracle Price oracle for Haber
     * @param _cryptoOracle Price oracle for crypto used for the collateral
     */
    function updateLoanDataOracle(
        uint _id,
        address _haberOracle,
        address _cryptoOracle
    ) external {
        FacetModifier.__onlyOwner();

        CryptoCollateralStorage.updateLoanDataOracle(
            _id,
            _haberOracle,
            _cryptoOracle
        );
        emit CryptoCollateralLoanOracleUpdated(
            _id,
            _haberOracle,
            _cryptoOracle
        );
    }

    /**
     * @notice This function deletes a loan data
     * @param _id ID of the loan data
     */
    function deleteLoanData(uint _id) external {
        FacetModifier.__onlyOwner();

        CryptoCollateralStorage.deleteLoanData(_id);
        emit CryptoCollateralLoanDeleted(_id);
    }

    /**
     * @notice This function gets some loan data
     * @param _id ID of the loan data to be queried
     * @return _haberOracle Price oracle for Haber
     * @return _loanAmount Loan amount that was requested
     * @return _loanTxNonce This keeps track of how many loan transaction hash there are
     * @return _cryptoOracle Price oracle for crypto used for the collateral
     * @return _cryptoAmount Amount of the crypto that was used as collateral for the loan
     * @return _collateralTxNonce This keeps track of how many collateral transaction hash there are
     * @return _totalOwedAmount The total amount to be paid including the loan amount and interest
     * @return _timeStamp Time the loan data was initiated
     */
    function getLoanData(
        uint _id
    )
        external
        returns (
            address _haberOracle,
            uint _loanAmount,
            uint _loanTxNonce,
            address _cryptoOracle,
            uint _cryptoAmount,
            uint _collateralTxNonce,
            uint _totalOwedAmount,
            uint _timeStamp
        )
    {
        return CryptoCollateralStorage.getLoanData(_id);
    }

    /**
     * @notice This function gets the current percentage of the collateral price to loan price
     * @param _id ID of the loan data
     * @return _loanPrice Price of the loan amount
     * @return _collateralPrice Price of the collateral amount
     * @return _collateralRatioPercent Percent of collateral price to loan price
     */
    function getCollateralRatioPercent(
        uint _id
    )
        external
        returns (
            uint _loanPrice,
            uint _collateralPrice,
            uint _collateralRatioPercent
        )
    {
        _loanPrice = getLoanAmountPrice(_id);
        _collateralPrice = getCollateralAmountPrice(_id);
        _collateralRatioPercent = (_collateralPrice / _loanPrice) * 100;
        return (_loanPrice, _collateralPrice, _collateralRatioPercent);
    }

    /**
     * @notice This function gets the collateral and liquidation percent
     * @return _collateralPercent Percent charged for collateral loan
     * @return _liquidationPercent The liquidation percent
     * @return _interestRatePercent The percent charged as daily interest rate on loans
     */
    function getAllLoanPercent()
        internal
        view
        returns (
            uint64 _collateralPercent,
            uint64 _liquidationPercent,
            uint128 _interestRatePercent
        )
    {
        return CryptoCollateralStorage.getAllLoanPercent();
    }

    /**
     * @notice This function calculates the price of loan amount
     * @param _id ID of the loan data
     * @return _price Price of loan amount
     */
    function getLoanAmountPrice(uint _id) internal returns (uint _price) {
        (
            address _haberOracle,
            uint _loanAmount,
            ,
            ,
            ,
            ,
            ,

        ) = CryptoCollateralStorage.getLoanData(_id);
        _price = _loanAmount * Utils.getOraclePrice(_haberOracle);
        return _price;
    }

    /**
     * @notice This function calculates the price of collateral amount
     * @param _id ID of the loan data
     * @return _price Price of collateral amount
     */
    function getCollateralAmountPrice(uint _id) internal returns (uint _price) {
        (
            ,
            ,
            ,
            address _cryptoOracle,
            uint _cryptoAmount,
            ,
            ,

        ) = CryptoCollateralStorage.getLoanData(_id);
        _price = _cryptoAmount * Utils.getOraclePrice(_cryptoOracle);
        return _price;
    }
}
