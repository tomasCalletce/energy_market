// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "../interfaces/AggregatorInterface.sol";

contract GetAggregators {

    AggregatorInterface public immutable oracle_kwhGeneration;
    AggregatorInterface public immutable oracle_waterForcast;

    constructor(address oracle_kwhGeneration_,address oracle_waterForcast_){
        oracle_kwhGeneration = AggregatorInterface(oracle_kwhGeneration_);
        oracle_waterForcast = AggregatorInterface(oracle_waterForcast_);
    }

    function _getOracle_kwhGeneration() internal view returns(uint){
        return oracle_kwhGeneration.latestRoundData().answer;
    }

    function _getOracle_waterForcast() internal view returns(uint){
        return oracle_waterForcast.latestRoundData().answer;
    }

}