/// Utils

//SPDX-FileCopyrightText: © 2023 Ndubuisi Favour <favourndubuisi.official@gmail.com>
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

///Libraries -->
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/**
 * @title utils Smart Contract Library
 * @notice This library helps keep utils functions
 */
library Utils {
    /**
     * @notice This function gets the price of an oracle
     * @param _oracleAddr Address of oracle to be queried
     * @return uint256 Price of oracle
     */
    function getOraclePrice(
        address _oracleAddr
    ) internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(_oracleAddr);
        (, int price, , , ) = priceFeed.latestRoundData();
        return uint(price);
    }

    /**
     * @notice This function gets the rounded value of a division
     * @param _numerator Value of numerator
     * @param _denominator Value of denominator
     * @return uint256 Rounded value
     */
    function round(
        uint256 _numerator,
        uint256 _denominator
    ) public pure returns (uint256) {
        uint256 halfDenominator = _denominator / 2;
        return (_numerator + halfDenominator) / _denominator;
    }
}
