// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Initializable } from "src/utils/Initializable.sol";
import { IDiamondLoupe, IDiamondLoupeStructs } from "./IDiamondLoupe.sol";
import { DiamondLoupeBehavior } from "./DiamondLoupeBehavior.sol";
import { IERC165 } from "src/facets/introspection/IERC165.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";

abstract contract DiamondLoupeBase is IDiamondLoupeStructs, Initializable {
    function __DiamondLoupe_init() internal onlyInitializing {
        IntrospectionBehavior.addInterface(type(IDiamondLoupe).interfaceId);
    }

    function _facetSelectors(address facet) internal view returns (bytes4[] memory) {
        return DiamondLoupeBehavior.facetSelectors(facet);
    }

    function _facetAddresses() internal view returns (address[] memory) {
        return DiamondLoupeBehavior.facetAddresses();
    }

    function _facetAddress(bytes4 selector) internal view returns (address) {
        return DiamondLoupeBehavior.facetAddress(selector);
    }

    function _facets() internal view returns (Facet[] memory facets) {
        address[] memory facetAddresses = _facetAddresses();
        uint256 facetCount = facetAddresses.length;
        facets = new Facet[](facetCount);

        // build up facets
        for (uint256 i = 0; i < facetCount; i++) {
            address facet = facetAddresses[i];
            bytes4[] memory selectors = _facetSelectors(facet);

            facets[i] = Facet({ facet: facet, selectors: selectors });
        }
    }
}
