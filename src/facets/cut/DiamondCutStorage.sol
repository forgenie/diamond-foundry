// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

// TODO: Create a separate EnumerableSet.Bytes4Set library where 8 selectors are stored into one storage slot
import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

library DiamondCutStorage {
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    bytes32 constant DIAMOND_CUT_STORAGE_POSITION = keccak256("diamond.cut.storage");

    struct Layout {
        EnumerableSet.AddressSet facets;
        mapping(bytes4 selector => address facet) selectorToFacet;
        mapping(address => EnumerableSet.Bytes32Set) facetSelectors;
    }

    function layout() internal pure returns (Layout storage l) {
        bytes32 position = DIAMOND_CUT_STORAGE_POSITION;

        assembly {
            l.slot := position
        }
    }
}
