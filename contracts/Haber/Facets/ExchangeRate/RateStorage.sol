/// Haber Token Exchange Rate Storage Library

//SPDX-FileCopyrightText: © 2023 Ndubuisi Favour <favourndubuisi.official@gmail.com>
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

///Libraries -->

/**
 * @title Exchange Rate Storage Smart Contract Library
 * @notice This library keeps storage of Haber token exchange rate
 */
library ExchangeRateStorage {
    /**
     * @notice This is Economy struct that holds details of the various world economies
     * @param country This holds the country name
     * @param currencySymbol This hold the currency symbol of the country's currency
     * @param priceOracle This holds the address of the country's currency price feed oracle
     */
    struct Economy {
        string country;
        string currencySymbol;
        address priceOracle;
    }

    /**
     * @notice This is layout struct of this facet's storage
     * @param currencyUnit This holds the base currency unit of account that the average of the various country's currency would be calculated in
     * @param economyData This holds the top five world economies that Haber token would derive it's price from
     */
    struct Layout {
        string currencyUnit; //This is used unit of currency worth
        Economy[5] economyData;
    }

    bytes32 internal constant EXCHANGE_RATE_SLOT =
        keccak256("lib.storage.ExchangeRate");

    /**
     * @notice This sets the layout of the facet struct
     * @return l Layout struct of FacetInitializeStorage
     */
    function layout() internal pure returns (Layout storage l) {
        bytes32 _slot = EXCHANGE_RATE_SLOT;
        assembly {
            l.slot := _slot
        }
    }

    /**
     * @notice This gets the currency unit value
     * @return string The currency unit that the average price would be calculated in
     */
    function getCurrencyUnit() internal view returns (string memory) {
        return layout().currencyUnit;
    }

    /**
     * @notice This gets the economy data of any of the top 5 ranked economies i.e 0 - 4
     * @param _rank The rank of the economy to be queried i.e 0 - 4
     * @return Economy The economy data of the country
     */
    function getEconomyData(
        uint64 _rank
    ) internal view returns (Economy memory) {
        return layout().economyData[_rank];
    }

    /**
     * @notice This sets the currency unit
     * @param _currencyUnit The currency unit to be used
     */
    function setCurrencyUnit(string memory _currencyUnit) internal {
        layout().currencyUnit = _currencyUnit;
    }

    /**
     * @notice This sets the economy data of the ranked world economies
     * @param _rank The rank of the economy to be set i.e 0 - 4
     * @param _economyData The updated economy data
     */
    function setEconomyData(
        uint64 _rank,
        Economy memory _economyData
    ) internal {
        layout().economyData[_rank] = _economyData;
    }
}
