// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamondLoupe } from "./IDiamondLoupe.sol";
import { DiamondLoupeBehavior } from "./DiamondLoupeBehavior.sol";

abstract contract DiamondLoupe is IDiamondLoupe {
    /// @inheritdoc IDiamondLoupe
    function facets() external view returns (Facet[] memory) {
        return DiamondLoupeBehavior.facets();
    }

    /// @inheritdoc IDiamondLoupe
    function facetFunctionSelectors(address facet) external view returns (bytes4[] memory) {
        return DiamondLoupeBehavior.facetSelectors(facet);
    }

    /// @inheritdoc IDiamondLoupe
    function facetAddresses() external view returns (address[] memory) {
        return DiamondLoupeBehavior.facetAddresses();
    }

    /// @inheritdoc IDiamondLoupe
    function facetAddress(bytes4 selector) external view returns (address) {
        return DiamondLoupeBehavior.facetAddress(selector);
    }
}
