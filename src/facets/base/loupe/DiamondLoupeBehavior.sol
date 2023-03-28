// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamondLoupe } from "./IDiamondLoupe.sol";
import { DiamondCutStorageBehavior } from "../cut/DiamondCutBehavior.sol";

library DiamondLoupeBehavior {
    function facetSelectors(address facet) internal view returns (bytes4[] memory) {
        return DiamondCutStorageBehavior.getFacetSelectors(facet);
    }

    function facetAddresses() internal view returns (address[] memory) {
        return DiamondCutStorageBehavior.getFacetAddresses();
    }

    function facetAddress(bytes4 selector) internal view returns (address) {
        return DiamondCutStorageBehavior.getFacetFromSelector(selector);
    }

    function facets() internal view returns (IDiamondLoupe.Facet[] memory facetInfo) {
        address[] memory facetAddrs = facetAddresses();
        facetInfo = new IDiamondLoupe.Facet[](facetAddrs.length);

        // build up facetInfo
        for (uint256 i = 0; i < facetAddrs.length; i++) {
            // get facet address
            address facet = facetAddrs[i];
            bytes4[] memory selectors = facetSelectors(facet);

            // set facet Info for this facet
            facetInfo[i] = IDiamondLoupe.Facet({ facetAddress: facet, functionSelectors: selectors });
        }
    }
}
