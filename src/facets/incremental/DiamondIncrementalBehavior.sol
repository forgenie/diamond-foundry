// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamondCut } from "src/facets/cut/IDiamondCut.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";
import { DiamondIncrementalStorage } from "./DiamondIncrementalStorage.sol";

error DiamondIncremental_immute_AlreadyImmutable(bytes4 selector);

library DiamondIncrementalBehavior {
    event SelectorTurnedImmutable(bytes4 indexed selector);

    function isImmutable(bytes4 selector) internal view returns (bool) {
        // if `diamondCut` method was removed all functions are immutable
        if (!IntrospectionBehavior.supportsInterface(type(IDiamondCut).interfaceId)) {
            return true;
        }
        return DiamondIncrementalStorage.layout().immutableFunctions[selector];
    }

    /// @notice Sets multiple functions as immutable.
    function immute(bytes4[] memory selectors) internal {
        for (uint256 i = 0; i < selectors.length; i++) {
            bytes4 selector = selectors[i];

            if (isImmutable(selector)) {
                revert DiamondIncremental_immute_AlreadyImmutable(selector);
            }

            DiamondIncrementalStorage.layout().immutableFunctions[selector] = true;

            emit SelectorTurnedImmutable(selector);
        }
    }
}
