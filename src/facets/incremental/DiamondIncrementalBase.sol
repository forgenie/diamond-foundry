// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { Initializable } from "src/utils/Initializable.sol";
import { IDiamondIncremental, IDiamondIncrementalEvents } from "./IDiamondIncremental.sol";
import { DiamondIncrementalBehavior } from "./DiamondIncrementalBehavior.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";

abstract contract DiamondIncrementalBase is IDiamondIncrementalEvents, Initializable {
    function __DiamondIncremental_init() internal {
        IntrospectionBehavior.addInterface(type(IDiamondIncremental).interfaceId);
    }

    function _turnImmutable(bytes4 selector) internal {
        DiamondIncrementalBehavior.turnImmutable(selector);

        emit SelectorTurnedImmutable(selector);
    }

    function _isImmutable(bytes4 selector) internal view returns (bool) {
        return DiamondIncrementalBehavior.isImmutable(selector);
    }
}
