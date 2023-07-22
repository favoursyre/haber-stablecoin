/// Collateral Storage Library

//SPDX-FileCopyrightText: © 2023 Ndubuisi Favour <favourndubuisi.official@gmail.com>
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

///Libraries -->
import {Utils} from "../../../Libraries/Utils.sol";

/**
 * @title Crypto Collateral Storage Smart Contract Library
 * @notice This library helps keeps storage of Haber collateral loans using crypto
 */
library CryptoCollateralStorage {
    /**
     * @notice This struct coins the neccessary info's for a crypto collateral loan
     * @param haberOracle Price oracle for Haber
     * @param loanAmount Loan amount that was requested
     * @param loanTxHashes This keeps track of the various transaction hash related with the loan transfers
     * @param loanTxNonce This keeps track of how many loan transaction hash there are
     * @param cryptoOracle Price oracle for crypto used for the collateral
     * @param cryptoAmount Amount of the crypto that was used as collateral for the loan
     * @param collateralTxHashes This keeps track of the various transaction hash related with the collateral transfers
     * @param collateralTxNonce This keeps track of how many collateral transaction hash there are
     * @param totalOwedAmount The total amount to be paid including the loan amount and interest
     * @param timeStamp Time the loan data was initiated
     */
    struct LoanInfo {
        address haberOracle;
        uint loanAmount;
        mapping(uint => bytes32) loanTxHashes;
        uint loanTxNonce;
        address cryptoOracle;
        uint cryptoAmount;
        mapping(uint => bytes32) collateralTxHashes;
        uint collateralTxNonce;
        uint totalOwedAmount;
        uint timeStamp;
    }

    /**
     * @notice This layout storage struct
     * @dev Pass in the calculated percent values e.g. If you want pass in 0.9%, pass in 0.009 instead
     * @param loanData This keeps track of all loan datas
     * @param interestRatePercent The percent charged as daily interest rate on loans
     * @param collateralPercent The percent charged for collateral
     * @param liquidationPercent The percent at which the collateral will be liquidated
     */
    struct Layout {
        mapping(uint => LoanInfo) loanData;
        uint128 interestRatePercent;
        uint64 collateralPercent;
        uint64 liquidationPercent;
    }

    /**
     * @notice This enum specifies the action to be taken when updating a loan data
     * @param ADD This adds the new amount to the existing one
     * @param SUB This subs the new amount from the existing one
     */
    enum UpdateAction {
        ADD,
        SUB
    }

    bytes32 internal constant CRYPTO_COLLATERAL_SLOT =
        keccak256("lib.storage.CryptoCollateral");

    /**
     * @notice This sets the layout of the facet struct
     * @return l Layout struct of FacetInitializeStorage
     */
    function layout() internal pure returns (Layout storage l) {
        bytes32 _slot = CRYPTO_COLLATERAL_SLOT;
        assembly {
            l.slot := _slot
        }
    }

    /**
     * @notice This function gets loan data
     * @param _id ID of the loan data
     * @return LoanInfo The loan data
     */
    function getLoanDataStruct(
        uint _id
    ) internal view returns (LoanInfo storage) {
        return layout().loanData[_id];
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
        internal
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
        _haberOracle = getLoanDataStruct(_id).haberOracle;
        _loanAmount = getLoanDataStruct(_id).loanAmount;
        _loanTxNonce = getLoanDataStruct(_id).loanTxNonce;
        _cryptoOracle = getLoanDataStruct(_id).cryptoOracle;
        _cryptoAmount = getLoanDataStruct(_id).cryptoAmount;
        _collateralTxNonce = getLoanDataStruct(_id).collateralTxNonce;
        _timeStamp = getLoanDataStruct(_id).timeStamp;
        setTotalOwedAmount(_id, _timeStamp, _loanAmount);
        _totalOwedAmount = getLoanDataStruct(_id).totalOwedAmount;

        return (
            _haberOracle,
            _loanAmount,
            _loanTxNonce,
            _cryptoOracle,
            _cryptoAmount,
            _collateralTxNonce,
            _totalOwedAmount,
            _timeStamp
        );
    }

    /**
     * @notice This function gets all the transaction hashes of transfered loans
     * @param _id ID of the loan data to be queried
     * @return _loanTxHashes This contains an array of all transaction hashes related to loan transfers for the queried loan data
     */
    function getAllLoanTxHash(
        uint _id
    ) internal view returns (bytes32[] memory _loanTxHashes) {
        bytes32[] memory _loanTxHash = new bytes32[](
            getLoanDataStruct(_id).loanTxNonce
        );
        for (uint i = 0; i < getLoanDataStruct(_id).loanTxNonce; i++) {
            _loanTxHashes[i] = getLoanDataStruct(_id).loanTxHashes[i];
        }
        return _loanTxHash;
    }

    /**
     * @notice This function gets all the transaction hashes of transfered collaterals
     * @param _id ID of the loan data to be queried
     * @return _collateralTxHashes This contains an array of all transaction hashes related to collateral transfers for the queried loan data
     */
    function getAllCollateralTxHash(
        uint _id
    ) internal view returns (bytes32[] memory _collateralTxHashes) {
        bytes32[] memory _collateralTxHash = new bytes32[](
            getLoanDataStruct(_id).collateralTxNonce
        );
        for (uint i = 0; i < getLoanDataStruct(_id).collateralTxNonce; i++) {
            _collateralTxHashes[i] = getLoanDataStruct(_id).collateralTxHashes[
                i
            ];
        }
        return _collateralTxHash;
    }

    /**
     * @notice This sets the collateral percent
     * @dev Pass in the calculated percent values e.g. If you want pass in 0.9%, pass in 0.009 instead
     * @param _collateralPercent The percent charged for collateral
     * @param _liquidationPercent The percent charged for liquidation
     * @param _interestRatePercent The percent charged as daily interest on loans
     */
    function setAllLoanPercent(
        uint64 _collateralPercent,
        uint64 _liquidationPercent,
        uint128 _interestRatePercent
    ) internal {
        layout().collateralPercent = _collateralPercent;
        layout().liquidationPercent = _liquidationPercent;
        layout().interestRatePercent = _interestRatePercent;
    }

    /**
     * @notice This adds new loan data to the collateral storage
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
    ) internal {
        LoanInfo storage _loanInfo = layout().loanData[_id];
        _loanInfo.haberOracle = _haberOracle;
        if (_loanAmount != 0) {
            _loanInfo.loanAmount = _loanAmount;
            _loanInfo.loanTxHashes[_loanInfo.loanTxNonce] = _loanTxHash;
            _loanInfo.loanTxNonce++;
        }
        _loanInfo.cryptoOracle = _cryptoOracle;
        _loanInfo.cryptoAmount = _cryptoAmount;
        _loanInfo.collateralTxHashes[
            _loanInfo.collateralTxNonce
        ] = _collateralTxHash;
        _loanInfo.collateralTxNonce++;
        _loanInfo.timeStamp = block.timestamp;
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
        UpdateAction _updateAction
    ) internal {
        LoanInfo storage _loanInfo = layout().loanData[_id];
        if (_updateAction == UpdateAction.ADD) {
            if (_loanAmount != 0) {
                _loanInfo.loanAmount = _loanInfo.loanAmount + _loanAmount;
                _loanInfo.loanTxHashes[_loanInfo.loanTxNonce] = _loanTxHash;
                _loanInfo.loanTxNonce++;
            } else if (_cryptoAmount != 0) {
                _loanInfo.cryptoAmount = _loanInfo.cryptoAmount + _cryptoAmount;
                _loanInfo.collateralTxHashes[
                    _loanInfo.collateralTxNonce
                ] = _collateralTxHash;
                _loanInfo.collateralTxNonce++;
            }
        } else if (_updateAction == UpdateAction.SUB) {
            if (_loanAmount != 0) {
                _loanInfo.loanAmount = _loanInfo.loanAmount - _loanAmount;
                _loanInfo.loanTxHashes[_loanInfo.loanTxNonce] = _loanTxHash;
                _loanInfo.loanTxNonce++;
            } else if (_cryptoAmount != 0) {
                _loanInfo.cryptoAmount = _loanInfo.cryptoAmount - _cryptoAmount;
                _loanInfo.collateralTxHashes[
                    _loanInfo.collateralTxNonce
                ] = _collateralTxHash;
                _loanInfo.collateralTxNonce++;
            }
        }
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
    ) internal {
        LoanInfo storage _loanInfo = layout().loanData[_id];
        if (_haberOracle != address(0)) {
            _loanInfo.haberOracle = _haberOracle;
        } else if (_cryptoOracle != address(0)) {
            _loanInfo.cryptoOracle = _cryptoOracle;
        }
    }

    /**
     * @notice This function deletes a loan data
     * @param _id ID of the loan data
     */
    function deleteLoanData(uint _id) internal {
        delete layout().loanData[_id];
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
        return (
            layout().collateralPercent,
            layout().liquidationPercent,
            layout().interestRatePercent
        );
    }

    /**
     * @notice This sets the total owed amount for a loan data
     * @param _id ID of the loan data to be queried
     * @param _timeStamp Time the loan data was initiated
     * @param _loanAmount Total amount of loan in the loan data
     */
    function setTotalOwedAmount(
        uint _id,
        uint _timeStamp,
        uint _loanAmount
    ) private {
        (, , uint128 _interestRatePercent) = getAllLoanPercent();
        uint _time = Utils.round((block.timestamp - _timeStamp), 86400); //86400 reps 24hr period (24 * 60 * 60)
        uint _interest = (_time * _interestRatePercent) * _loanAmount;
        LoanInfo storage _loanInfo = layout().loanData[_id];
        _loanInfo.totalOwedAmount = _interest + _loanAmount;
    }
}
