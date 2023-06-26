// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamondCut } from "src/facets/cut/IDiamondCut.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";
import { DiamondIncrementalStorage } from "./DiamondIncrementalStorage.sol";

error DiamondIncremental_AlreadyImmutable(bytes4 selector);
error DiamondIncremental_ImmutableFunction(bytes4 selector);

library DiamondIncrementalBehavior {
    function checkImmutable(bytes4 selector) internal view {
        if (isImmutable(selector)) {
            revert DiamondIncremental_ImmutableFunction(selector);
        }
    }

    function isImmutable(bytes4 selector) internal view returns (bool) {
        // if `diamondCut` method was removed all functions are immutable
        if (!IntrospectionBehavior.supportsInterface(type(IDiamondCut).interfaceId)) {
            return true;
        }
        return DiamondIncrementalStorage.layout().immutableFunctions[selector];
    }

    function turnImmutable(bytes4 selector) internal {
        if (isImmutable(selector)) {
            revert DiamondIncremental_AlreadyImmutable(selector);
        }

        DiamondIncrementalStorage.layout().immutableFunctions[selector] = true;
    }
}
