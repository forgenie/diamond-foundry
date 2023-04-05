// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { IFacetRegistry } from "./IFacetRegistry.sol";

library FacetRegistryStorage {
    using EnumerableSet for EnumerableSet.Bytes32Set;

    bytes32 public constant FACET_REGISTRY_STORAGE_POSITION = keccak256("facet.registry.storage");

    struct FacetData {
        address addr;
        bytes4 initializer;
        bytes4 interfaceId;
        // bytes4 version;
        EnumerableSet.Bytes32Set selectors;
    }

    struct Layout {
        mapping(address facet => bytes32 facetId) facetIds;
        mapping(bytes32 facetId => FacetData facetData) facets;
    }

    function addFacet(Layout storage self, IFacetRegistry.FacetInfo memory facetInfo, bytes32 facetId) internal {
        self.facetIds[facetInfo.addr] = facetId;
        self.facets[facetId].addr = facetInfo.addr;
        self.facets[facetId].initializer = facetInfo.initializer;

        bytes4 interfaceId;
        for (uint256 i = 0; i < facetInfo.selectors.length; i++) {
            bytes4 selector = facetInfo.selectors[i];

            if (selector == bytes4(0)) continue;

            self.facets[facetId].selectors.add(selector);
            // XOR selectors to get interfaceId
            i == 0 ? interfaceId = selector : interfaceId ^= selector;
        }
        self.facets[facetId].interfaceId = interfaceId;
    }

    function removeFacet(Layout storage self, bytes32 facetId) internal {
        address facet = self.facets[facetId].addr;

        delete self.facetIds[facet];
        delete self.facets[facetId].addr;
        delete self.facets[facetId].initializer;
        delete self.facets[facetId].interfaceId;

        uint256 selectorCount = self.facets[facetId].selectors.length();
        for (uint256 i = 0; i < selectorCount; i++) {
            bytes4 selector = bytes4(self.facets[facetId].selectors.at(i));

            self.facets[facetId].selectors.remove(selector);
        }
    }

    function layout() internal pure returns (Layout storage l) {
        bytes32 position = FACET_REGISTRY_STORAGE_POSITION;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            l.slot := position
        }
    }
}