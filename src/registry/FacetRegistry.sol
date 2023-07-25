// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { IFacetRegistry } from "./IFacetRegistry.sol";
import { FacetRegistryBase } from "./FacetRegistryBase.sol";

// todo: transform this contract into a facet
contract FacetRegistry is IFacetRegistry, FacetRegistryBase {
    /// @inheritdoc IFacetRegistry
    function addFacet(address facet, bytes4[] memory selectors) external {
        _addFacet(facet, selectors);
    }

    /// @inheritdoc IFacetRegistry
    function removeFacet(address facet) external {
        _removeFacet(facet);
    }

    /// @inheritdoc IFacetRegistry
    function deployFacet(
        bytes32 salt,
        bytes memory creationCode,
        bytes4[] memory selectors
    )
        external
        override
        returns (address facet)
    {
        facet = _deployFacet(salt, creationCode, selectors);
    }

    /// @inheritdoc IFacetRegistry
    function computeFacetAddress(
        bytes32 salt,
        bytes memory creationCode
    )
        external
        view
        override
        returns (address facet)
    {
        facet = _computeFacetAddress(salt, creationCode);
    }

    /// @inheritdoc IFacetRegistry
    function facetSelectors(address facet) external view returns (bytes4[] memory) {
        return _facetSelectors(facet);
    }

    /// @inheritdoc IFacetRegistry
    function facetAddresses() external view returns (address[] memory) {
        return _facetAddresses();
    }
}
