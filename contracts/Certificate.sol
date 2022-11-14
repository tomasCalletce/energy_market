// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./utils/GetAggregators.sol";

contract MyToken is ERC721, Pausable, AccessControl, GetAggregators {
    using Counters for Counters.Counter;

    struct LeverageCertificate {
        uint kwhGeneration;
        uint waterForcast;
        uint timeStampCreation;
        uint timeStampMaturity;
        bool claimed;
    }

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant POWER_PLANT = keccak256("POWER_PLANT");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    mapping(uint => LeverageCertificate) public leverageCertificates;

    Counters.Counter private _tokenIdCounter;

    constructor(
        address powerPlant,
        address oracle_kwhGeneration,
        address oracle_waterForcas,
        string memory name,
        string memory ticker
        )
        ERC721(name,ticker) 
        GetAggregators(oracle_kwhGeneration,oracle_waterForcas){
            
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(BURNER_ROLE, msg.sender);
        _grantRole(POWER_PLANT, powerPlant);
        _tokenIdCounter.increment();
    }

    function pause() external onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function safeMint(address to) external onlyRole(POWER_PLANT) {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        require(leverageCertificates[tokenId-1].timeStampMaturity < block.timestamp);
        _safeMint(to, tokenId);
        leverageCertificates[tokenId] = LeverageCertificate(
            _getOracle_kwhGeneration(),
            _getOracle_waterForcast(),
            block.timestamp,
            block.timestamp + 4 weeks,
            false
        );
    }

    function burn(uint id) external onlyRole(BURNER_ROLE) {
        _burn(id);
        leverageCertificates[id].claimed = true;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize) internal whenNotPaused override {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    // The following functions are overrides required by Solidity.
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}