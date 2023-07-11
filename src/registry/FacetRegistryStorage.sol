// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

library FacetRegistryStorage {
    bytes32 public constant FACET_REGISTRY_STORAGE_POSITION = keccak256("facet.registry.storage");

    struct Layout {
        EnumerableSet.AddressSet facets;
        mapping(address facet => EnumerableSet.Bytes32Set selectors) facetSelectors;
    }

    function layout() internal pure returns (Layout storage l) {
        bytes32 position = FACET_REGISTRY_STORAGE_POSITION;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            l.slot := position
        }
    }
}
