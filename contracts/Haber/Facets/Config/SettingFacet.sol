/// Haber Settings

//SPDX-FileCopyrightText: © 2023 Ndubuisi Favour <favourndubuisi.official@gmail.com>
//SPDX-License-Identifier: BSD-3-Clause

pragma solidity ^0.8.17;

///Libraries -->
import {FacetModifier} from "../../../Libraries/FacetModifier.sol";
import {ERC20Storage} from "../ERC20/ERC20Storage.sol";
import {CryptoCollateralStorage} from "../Collateral/CollateralStorage.sol";
import "hardhat/console.sol";

/**
 * @title Haber Setting Facet Smart Contract
 */
contract SettingFacet {
    /// ~~~~~~~~~~~~~~~~ Declaring the necessary events for this facet ~~~~~~~~~~~~~~~~
    /**
     * @notice This emits whenever Kleinrock's central bank address is updated
     * @param _centralBank The new central bank address
     */
    event CentralBankUpdated(address indexed _centralBank);

    /**
     * @notice This emits whenever foundation wallet is updated
     * @param _foundationWallet Contains an array of [_transferFeePercent, _centralBankPercent, _centralBankPercent, _foundationPercent]
     */
    event FoundationWalletUpdated(address indexed _foundationWallet);

    /**
     * @notice This emits whenever the threshold amount has been updated
     * @param _amount The new threshold amount
     */
    event ThresholdUpdated(uint _amount);

    // /**
    //  * @notice This emits whenever the transfer fee percent has been updated
    //  * @param _transferFeePercent The new transfer fee percent
    //  */
    // event TransferFeePercentUpdated(uint64 indexed _transferFeePercent);

    /**
     * @notice This emits whenever the owner and miner's percent of the transfer has been updated
     * @param _allPercent Contains an array of [_transferFeePercent, _centralBankPercent, _centralBankPercent, _foundationPercent]
     */
    event AllRewardPercentUpdated(uint64[4] indexed _allPercent);

    // /**
    //  * @notice This emits whenever the collateral percent has been updated
    //  * @param _collateralPercent The new collateral percent
    //  */
    // event CollateralPercentUpdated(uint128 indexed _collateralPercent);

    /**
     * @notice This emits whenever the liquidation percent has been updated
     * @param _collateralPercent The new collateral percent
     * @param _liquidationPercent The new liquidation percent
     */
    event AllLoanPercentUpdated(
        uint64 indexed _collateralPercent,
        uint64 indexed _liquidationPercent,
        uint128 indexed _interestRatePercent
    );

    /// ~~~~~~~~~~~~~~~~ Declaring the necessary functions for this facet ~~~~~~~~~~~~~~~~
    /**
     * @notice This is the init function of this facet
     * @dev Pass in the calculated percent values e.g. If you want pass in 0.9%, pass in 0.009 instead
     * @param _centralBank Wallet address of kleinrock central bank
     * @param _foundationWallet Wallet address of Good Life Foundation
     * @param _thresholdAmount Threshold amount for large transfers, etc.
     * @param _transferFeePercent Percent charged on every transfers, e.g
     * @param _centralBankPercent Central Bank's percent of transfer fee
     * @param _minerPercent Miner's percent of transfer fee
     * @param _foundationPercent Foundation's percent of transfer fee
     * @param _collateralPercent Collateral percent threshold
     * @param _liquidationPercent Percent at which collateral would be liquidated
     * @param _interestRatePercent Percent of daily interest charged for borrowing Haber token
     */
    function __initSettingFacet(
        address _centralBank,
        address _foundationWallet,
        uint256 _thresholdAmount,
        uint64 _transferFeePercent,
        uint64 _centralBankPercent,
        uint64 _minerPercent,
        uint64 _foundationPercent,
        uint64 _collateralPercent,
        uint64 _liquidationPercent,
        uint128 _interestRatePercent
    ) external {
        FacetModifier.__initializeOnce(address(this));

        setCentralBank(_centralBank);
        setThreshold(_thresholdAmount);
        setFoundationWallet(_foundationWallet);
        setAllRewardPercent(
            _transferFeePercent,
            _centralBankPercent,
            _minerPercent,
            _foundationPercent
        );
        setAllLoanPercent(
            _collateralPercent,
            _liquidationPercent,
            _interestRatePercent
        );
    }

    /**
     * @notice This sets the central bank address
     * @param _address Wallet address of kleinrock central bank
     */
    function setCentralBank(address _address) public {
        FacetModifier.__onlyOwner();

        ERC20Storage.setCentralBank(_address);
        emit CentralBankUpdated(_address);
    }

    /**
     * @notice This sets the foundation wallet address
     * @param _address Address of foundation wallet
     */
    function setFoundationWallet(address _address) public {
        FacetModifier.__onlyOwner();

        ERC20Storage.setFoundationWallet(_address);
        emit FoundationWalletUpdated(_address);
    }

    /**
     * @notice This sets the threshold amount
     * @param _amount Threshold amount
     */
    function setThreshold(uint256 _amount) public {
        FacetModifier.__onlyOwner();

        ERC20Storage.setThreshold(_amount);
        emit ThresholdUpdated(_amount);
    }

    /**
     * @notice This sets the owner, miner and foundation's percent
     * @param transferFeePercent Percent to be charged on every transfer
     * @param centralBankPercent Owner's percent of transfer fee
     * @param minerPercent Miner's percent of transfer fee
     * @param foundationPercent Foundation's percent of transfer fee
     */
    function setAllRewardPercent(
        uint64 transferFeePercent,
        uint64 centralBankPercent,
        uint64 minerPercent,
        uint64 foundationPercent
    ) public {
        FacetModifier.__onlyOwner();

        ERC20Storage.setAllPercent(
            transferFeePercent,
            centralBankPercent,
            minerPercent,
            foundationPercent
        );
        (
            uint64 _transferFeePercent,
            uint64 _centralBankPercent,
            uint64 _minerPercent,
            uint64 _foundationPercent
        ) = ERC20Storage.getAllPercent();
        emit AllRewardPercentUpdated(
            [
                _transferFeePercent,
                _centralBankPercent,
                _minerPercent,
                _foundationPercent
            ]
        );
    }

    /**
     * @notice This sets the collateral and liquidation percent for loans
     * @param _collateralPercent The percent charged for collateral
     * @param _liquidationPercent The percent charged for liquidation
     * @param _interestRatePercent The percent charged for daily interest rate
     */
    function setAllLoanPercent(
        uint64 _collateralPercent,
        uint64 _liquidationPercent,
        uint128 _interestRatePercent
    ) internal {
        FacetModifier.__onlyOwner();

        CryptoCollateralStorage.setAllLoanPercent(
            _collateralPercent,
            _liquidationPercent,
            _interestRatePercent
        );
        emit AllLoanPercentUpdated(
            _collateralPercent,
            _liquidationPercent,
            _interestRatePercent
        );
    }
}
