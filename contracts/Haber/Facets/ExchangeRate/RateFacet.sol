/// Haber Token Exchange Rate Facet

//SPDX-FileCopyrightText: © 2023 Ndubuisi Favour <favourndubuisi.official@gmail.com>
//SPDX-License-Identifier: BSD-3-Clause

pragma solidity ^0.8.17;

///Libraries -->
import {FacetModifier} from "../../../Libraries/FacetModifier.sol";
import {Utils} from "../../../Libraries/Utils.sol";
import {ERC20Storage} from "../ERC20/ERC20Storage.sol";
import {ExchangeRateStorage} from "./RateStorage.sol";
import "hardhat/console.sol";

/**
 * @title Exchange Rate Facet Smart Contract
 */
contract ExchangeRateFacet {
    /// ~~~~~~~~~~~~~~~~ Declaring the necessary events for this facet ~~~~~~~~~~~~~~~~
    /**
     * @notice This emits whenever the currency unit is updated
     * @param _newUnit The new currency unit
     */
    event CurrencyUnitUpdated(string indexed _newUnit);

    /**
     * @notice This emits whenever an economy data is updated
     * @param _rank The rank of the top 5 world economy to be updated
     * @param _economyData The updated economy data
     */
    event EconomyUpdated(
        uint indexed _rank,
        ExchangeRateStorage.Economy indexed _economyData
    );

    /**
     * @notice This emits whenever the exchange rate is updated
     * @param _newRate The new exchange rate for Haber stablecoin
     */
    event ExchangeRateUpdated(uint indexed _newRate);

    /// ~~~~~~~~~~~~~~~~ Declaring the necessary functions for this facet ~~~~~~~~~~~~~~~~
    /**
     * @notice This is the init function of this facet
     * @param _currencyUnit The currency unit
     * @param _economyData1 The economy data of the first world economy
     * @param _economyData2 The economy data of the second world economy
     * @param _economyData3 The economy data of the third world economy
     * @param _economyData4 The economy data of the fourth world economy
     * @param _economyData5 The economy data of the fifth world economy
     */
    function __initExchangeRateFacet(
        string calldata _currencyUnit,
        ExchangeRateStorage.Economy calldata _economyData1,
        ExchangeRateStorage.Economy calldata _economyData2,
        ExchangeRateStorage.Economy calldata _economyData3,
        ExchangeRateStorage.Economy calldata _economyData4,
        ExchangeRateStorage.Economy calldata _economyData5
    ) external {
        FacetModifier.__initializeOnce(address(this));

        setCurrencyUnit(_currencyUnit);
        setEconomyData(0, _economyData1);
        setEconomyData(1, _economyData2);
        setEconomyData(2, _economyData3);
        setEconomyData(3, _economyData4);
        setEconomyData(5, _economyData5);
    }

    /**
     * @notice This function updates the exchange rate,
     * this runs automatically every 12am WAT
     */
    function updateExchangeRate() external {
        FacetModifier.__onlyOwner();

        uint totalRate;
        for (uint64 i = 0; i < 5; i++) {
            //console.log("Total Rate: ", totalRate);
            ExchangeRateStorage.Economy memory data = ExchangeRateStorage
                .getEconomyData(i);
            //console.log("Data: ", data);
            if (
                keccak256(
                    abi.encodePacked(ExchangeRateStorage.getCurrencyUnit())
                ) == keccak256(abi.encodePacked(data.currencySymbol))
            ) {
                //if a ranked economy has the same currency as the currency unit, the price would be 1
                totalRate = totalRate + 1;
            } else {
                totalRate = totalRate + Utils.getOraclePrice(data.priceOracle);
            }
        }
        uint64 _exchangeRate = uint64(totalRate / 5);
        ERC20Storage.setExchangeRate(_exchangeRate);
        console.log("Exchange Rate: ", _exchangeRate);
        emit ExchangeRateUpdated(_exchangeRate);
    }

    /**
     * @notice This sets the currency unit
     * @param _currencyUnit The currency unit
     */
    function setCurrencyUnit(string memory _currencyUnit) public {
        FacetModifier.__onlyOwner();

        ExchangeRateStorage.setCurrencyUnit(_currencyUnit);
        emit CurrencyUnitUpdated(_currencyUnit);
    }

    /**
     * @notice This sets the economy data of the ranked world economies
     * @param _rank The rank of the economy to be set i.e 0 - 4
     * @param _economyData The updated economy data
     */
    function setEconomyData(
        uint64 _rank,
        ExchangeRateStorage.Economy memory _economyData
    ) public {
        FacetModifier.__onlyOwner();

        ExchangeRateStorage.setEconomyData(_rank, _economyData);
        emit EconomyUpdated(_rank, _economyData);
    }
}
