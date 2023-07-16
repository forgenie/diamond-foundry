// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { Initializable } from "src/utils/Initializable.sol";
import { IDiamondCut } from "src/facets/cut/IDiamondCut.sol";
import { IDiamondIncremental, IDiamondIncrementalBase } from "./IDiamondIncremental.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";
import { DiamondIncrementalStorage } from "./DiamondIncrementalStorage.sol";

abstract contract DiamondIncrementalBase is IDiamondIncrementalBase, Initializable {
    function __DiamondIncremental_init() internal {
        IntrospectionBehavior.addInterface(type(IDiamondIncremental).interfaceId);
    }

    function _turnImmutable(bytes4 selector) internal {
        if (_isImmutable(selector)) {
            revert DiamondIncremental_AlreadyImmutable(selector);
        }
        DiamondIncrementalStorage.layout().immutableFunctions[selector] = true;

        emit SelectorTurnedImmutable(selector);
    }

    function _isImmutable(bytes4 selector) internal view returns (bool) {
        // if `diamondCut` method was removed all functions are immutable
        if (!IntrospectionBehavior.supportsInterface(type(IDiamondCut).interfaceId)) {
            return true;
        }
        return DiamondIncrementalStorage.layout().immutableFunctions[selector];
    }
}
