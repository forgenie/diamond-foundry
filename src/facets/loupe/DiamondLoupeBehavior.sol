// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { IDiamondLoupe } from "./IDiamondLoupe.sol";
import { DiamondCutStorage } from "../cut/DiamondCutStorage.sol";

library DiamondLoupeBehavior {
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    function facetSelectors(address facet) internal view returns (bytes4[] memory selectors) {
        EnumerableSet.Bytes32Set storage facetSelectors_ = DiamondCutStorage.layout().facetSelectors[facet];
        uint256 selectorCount = facetSelectors_.length();
        selectors = new bytes4[](selectorCount);
        for (uint256 i = 0; i < selectorCount; i++) {
            selectors[i] = bytes4(facetSelectors_.at(i));
        }
    }

    function facetAddresses() internal view returns (address[] memory) {
        return DiamondCutStorage.layout().facets.values();
    }

    function facetAddress(bytes4 selector) internal view returns (address) {
        return DiamondCutStorage.layout().selectorToFacet[selector];
    }
}
