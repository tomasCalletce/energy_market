// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface AggregatorInterface {

    struct DataPoint{
        uint192 answer; 
        uint64 timestamp;
    }

    function roundById(uint _roundId) external view returns (DataPoint memory);
    function latestRoundData()external view returns (DataPoint memory);
    function description() external pure returns (string memory);
}