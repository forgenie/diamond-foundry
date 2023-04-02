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

        emit FacetRegistered(facetId, facetInfo.addr);
    }

    /// @inheritdoc IFacetRegistry
    function removeFacet(bytes32 facetId) external {
        address facet = FacetRegistryStorage.layout().facets[facetId].addr;

        FacetRegistryStorage.layout().removeFacet(facetId);

        emit FacetRemoved(facetId, facet);
    }

    /// @inheritdoc IFacetRegistry
    function computeFacetId(string calldata name) public view returns (bytes32) {
        if (bytes(name).length == 0) revert FacetRegistry_computeFacetId_NameEmpty();

        return keccak256(abi.encodePacked(block.chainid, address(this), name));
    }

    /// @inheritdoc IFacetRegistry
    function getFacetId(address facet) external view returns (bytes32) {
        return FacetRegistryStorage.layout().facetIds[facet];
    }

    /// @inheritdoc IFacetRegistry
    function getFacetAddress(bytes32 facetId) external view returns (address) {
        return FacetRegistryStorage.layout().facets[facetId].addr;
    }

    /// @inheritdoc IFacetRegistry
    function getInitializer(bytes32 facetId) external view override returns (bytes4) {
        return FacetRegistryStorage.layout().facets[facetId].initializer;
    }

    /// @inheritdoc IFacetRegistry
    function getFacetInterface(bytes32 facetId) external view override returns (bytes4) {
        return FacetRegistryStorage.layout().facets[facetId].interfaceId;
    }

    /// @inheritdoc IFacetRegistry
    function getFacetSelectors(bytes32 facetId) external view override returns (bytes4[] memory selectors) {
        bytes32[] memory selectorBytes = FacetRegistryStorage.layout().facets[facetId].selectors.values();

        selectors = new bytes4[](selectorBytes.length);

        for (uint256 i; i < selectorBytes.length; i++) {
            selectors[i] = bytes4(selectorBytes[i]);
        }
    }
}
