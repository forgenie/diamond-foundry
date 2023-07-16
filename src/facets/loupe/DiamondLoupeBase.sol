// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { DiamondCutStorage } from "src/facets/cut/DiamondCutStorage.sol";
import { IDiamondLoupe, IDiamondLoupeBase } from "./IDiamondLoupe.sol";
import { IERC165 } from "src/facets/introspection/IERC165.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";

abstract contract DiamondLoupeBase is IDiamondLoupeBase {
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    function __DiamondLoupe_init() internal {
        IntrospectionBehavior.addInterface(type(IDiamondLoupe).interfaceId);
    }

    function _facetSelectors(address facet) internal view returns (bytes4[] memory selectors) {
        EnumerableSet.Bytes32Set storage facetSelectors_ = DiamondCutStorage.layout().facetSelectors[facet];
        uint256 selectorCount = facetSelectors_.length();
        selectors = new bytes4[](selectorCount);
        for (uint256 i = 0; i < selectorCount; i++) {
            selectors[i] = bytes4(facetSelectors_.at(i));
        }
    }

    function _facetAddresses() internal view returns (address[] memory) {
        return DiamondCutStorage.layout().facets.values();
    }

    function _facetAddress(bytes4 selector) internal view returns (address) {
        return DiamondCutStorage.layout().selectorToFacet[selector];
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
