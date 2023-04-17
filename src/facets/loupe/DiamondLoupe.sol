// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamondLoupe } from "./IDiamondLoupe.sol";
import { DiamondLoupeBehavior } from "./DiamondLoupeBehavior.sol";
import { Facet } from "src/facets/BaseFacet.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";

abstract contract DiamondLoupe is IDiamondLoupe, Facet {
    function __DiamondLoupe_init() internal onlyInitializing {
        IntrospectionBehavior.addInterface(type(IDiamondLoupe).interfaceId);
    }

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
