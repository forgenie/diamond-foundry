// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

import { IFacetRegistry } from "./IFacetRegistry.sol";
import { FacetRegistryStorage } from "./FacetRegistryStorage.sol";

error FacetRegistry_computeFacetId_NameEmpty();

contract FacetRegistry is IFacetRegistry {
    using EnumerableSet for EnumerableSet.Bytes32Set;
    using FacetRegistryStorage for FacetRegistryStorage.Layout;

    /// @inheritdoc IFacetRegistry
    function registerFacet(FacetInfo calldata facetInfo) external {
        bytes32 facetId = computeFacetId(facetInfo.name);

        FacetRegistryStorage.layout().addFacet(facetInfo, facetId);
    }

    /// @inheritdoc IFacetRegistry
    function computeFacetId(string calldata name) public view returns (bytes32 facetId) {
        if (bytes(name).length == 0) revert FacetRegistry_computeFacetId_NameEmpty();

        return keccak256(abi.encodePacked(block.chainid, address(this), name));
    }

    /// @inheritdoc IFacetRegistry
    function getFacetId(address facet) external view returns (bytes32 facetId) {
        return FacetRegistryStorage.layout().facetIds[facet];
    }

    /// @inheritdoc IFacetRegistry
    function getInitializer(bytes32 facetId) external view override returns (bytes4) {
        return FacetRegistryStorage.layout().facets[facetId].initializer;
    }

    /// @inheritdoc IFacetRegistry
    function getFacetInterface(bytes32 facetId) external view override returns (bytes4 interfaceId) {
        return FacetRegistryStorage.layout().facets[facetId].interfaceId;
    }

    /// @inheritdoc IFacetRegistry
    function getFacetSelectors(bytes32 facetId) external view override returns (bytes32[] memory selectors) {
        return FacetRegistryStorage.layout().facets[facetId].selectors.values();
    }
}
