// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamondLoupe } from "./IDiamondLoupe.sol";
import { DiamondLoupeBehavior } from "./DiamondLoupeBehavior.sol";

abstract contract DiamondLoupe is IDiamondLoupe {
    /// @inheritdoc IDiamondLoupe
    function facets() public view returns (Facet[] memory) {
        return DiamondLoupeBehavior.facets();
    }

    /// @inheritdoc IDiamondLoupe
    function facetFunctionSelectors(address facet) public view returns (bytes4[] memory) {
        return DiamondLoupeBehavior.facetSelectors(facet);
    }

    /// @inheritdoc IDiamondLoupe
    function facetAddresses() public view returns (address[] memory) {
        return DiamondLoupeBehavior.facetAddresses();
    }

    /// @inheritdoc IDiamondLoupe
    function facetAddress(bytes4 selector) public view returns (address) {
        return DiamondLoupeBehavior.facetAddress(selector);
    }
}
