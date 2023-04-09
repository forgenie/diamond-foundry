// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { IFacetRegistry } from "./IFacetRegistry.sol";
import { FacetRegistryStorage } from "./FacetRegistryStorage.sol";

import {
    FacetRegistry_registerFacet_FacetAlreadyRegistered,
    FacetRegistry_validateFacetInfo_FacetAddressZero,
    FacetRegistry_validateFacetInfo_FacetMustHaveSelectors,
    FacetRegistry_validateFacetInfo_FacetNameEmpty,
    FacetRegistry_removeFacet_FacetNotRegistered
} from "./Errors.sol";

contract FacetRegistry is IFacetRegistry {
    using EnumerableSet for EnumerableSet.Bytes32Set;
    using FacetRegistryStorage for FacetRegistryStorage.Layout;

    // solhint-disable-next-line no-empty-blocks
    constructor() { }

    /// @inheritdoc IFacetRegistry
    function registerFacet(FacetInfo calldata facetInfo) external {
        _validateFacetInfo(facetInfo);

        bytes32 facetId = computeFacetId(facetInfo.name);
        if (getFacetAddress(facetId) != address(0)) revert FacetRegistry_registerFacet_FacetAlreadyRegistered();

        FacetRegistryStorage.layout().addFacet(facetInfo, facetId);

        emit FacetImplementationSet(facetId, facetInfo.addr);
    }

    /// @inheritdoc IFacetRegistry
    function removeFacet(bytes32 facetId) external {
        address facet = FacetRegistryStorage.layout().facets[facetId].addr;

        if (facet == address(0)) revert FacetRegistry_removeFacet_FacetNotRegistered();

        FacetRegistryStorage.layout().removeFacet(facetId);

        emit FacetImplementationSet(facetId, address(0));
    }

    /// @inheritdoc IFacetRegistry
    function computeFacetId(string calldata name) public view returns (bytes32) {
        return keccak256(abi.encodePacked(block.chainid, address(this), name));
    }

    /// @inheritdoc IFacetRegistry
    function getFacetId(address facet) public view returns (bytes32) {
        return FacetRegistryStorage.layout().facetIds[facet];
    }

    /// @inheritdoc IFacetRegistry
    function getFacetAddress(bytes32 facetId) public view returns (address) {
        return FacetRegistryStorage.layout().facets[facetId].addr;
    }

    /// @inheritdoc IFacetRegistry
    function getInitializer(bytes32 facetId) public view override returns (bytes4) {
        return FacetRegistryStorage.layout().facets[facetId].initializer;
    }

    /// @inheritdoc IFacetRegistry
    function getFacetInterface(bytes32 facetId) public view override returns (bytes4) {
        return FacetRegistryStorage.layout().facets[facetId].interfaceId;
    }

    /// @inheritdoc IFacetRegistry
    function getFacetSelectors(bytes32 facetId) public view override returns (bytes4[] memory selectors) {
        // just make the Bytes4Set bro
        bytes32[] memory selectorBytes = FacetRegistryStorage.layout().facets[facetId].selectors.values();

        selectors = new bytes4[](selectorBytes.length);

        for (uint256 i; i < selectorBytes.length; i++) {
            selectors[i] = bytes4(selectorBytes[i]);
        }
    }

    function _validateFacetInfo(FacetInfo calldata facetInfo) internal pure {
        if (facetInfo.addr == address(0)) revert FacetRegistry_validateFacetInfo_FacetAddressZero();
        if (facetInfo.selectors.length == 0) revert FacetRegistry_validateFacetInfo_FacetMustHaveSelectors();
        if (bytes(facetInfo.name).length == 0) revert FacetRegistry_validateFacetInfo_FacetNameEmpty();
    }
}
