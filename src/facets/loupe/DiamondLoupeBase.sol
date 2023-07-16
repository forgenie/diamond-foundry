// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { DiamondCutStorage } from "src/facets/cut/DiamondCutStorage.sol";
import { IDiamondLoupe, IERC165, IDiamondLoupeBase } from "./IDiamondLoupe.sol";
import { DiamondLoupeStorage } from "./DiamondLoupeStorage.sol";

abstract contract DiamondLoupeBase is IDiamondLoupeBase {
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.Bytes32Set;

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

        // Build up facet struct.
        for (uint256 i = 0; i < facetCount; i++) {
            address facet = facetAddresses[i];
            bytes4[] memory selectors = _facetSelectors(facet);

            facets[i] = Facet({ facet: facet, selectors: selectors });
        }
    }

    function _supportsInterface(bytes4 interfaceId) internal view returns (bool) {
        return DiamondLoupeStorage.layout().supportedInterfaces[interfaceId];
    }

    function _addInterface(bytes4 interfaceId) internal {
        DiamondLoupeStorage.layout().supportedInterfaces[interfaceId] = true;
    }

    function _removeInterface(bytes4 interfaceId) internal {
        DiamondLoupeStorage.layout().supportedInterfaces[interfaceId] = false;
    }
}
