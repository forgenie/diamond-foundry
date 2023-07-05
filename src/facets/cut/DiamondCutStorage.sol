// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

library DiamondCutStorage {
    bytes32 internal constant DIAMOND_CUT_STORAGE_POSITION = keccak256("diamond.cut.storage");

    struct Layout {
        EnumerableSet.AddressSet facets;
        mapping(bytes4 selector => address facet) selectorToFacet;
        mapping(address facet => EnumerableSet.Bytes32Set selectors) facetSelectors;
    }

    function layout() internal pure returns (Layout storage l) {
        bytes32 position = DIAMOND_CUT_STORAGE_POSITION;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            l.slot := position
        }
    }
}
