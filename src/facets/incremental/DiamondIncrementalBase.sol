// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Initializable } from "src/utils/Initializable.sol";
import { IDiamondIncremental, IDiamondIncrementalEvents } from "./IDiamondIncremental.sol";
import { DiamondIncrementalBehavior } from "./DiamondIncrementalBehavior.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";
import { OwnableBehavior } from "src/facets/ownable/OwnableBehavior.sol";

abstract contract DiamondIncrementalBase is IDiamondIncrementalEvents, Initializable {
    function __DiamondIncremental_init() internal onlyInitializing {
        IntrospectionBehavior.addInterface(type(IDiamondIncremental).interfaceId);
    }

    function _turnImmutable(bytes4 selector) internal {
        _authorizeImmute(selector);
        DiamondIncrementalBehavior.turnImmutable(selector);

        emit SelectorTurnedImmutable(selector);
    }

    /// @dev Allow inheriting contracts implement other authorization logic
    //       ownable behavior is used by default.
    function _authorizeImmute(bytes4) internal virtual {
        OwnableBehavior.checkOwner(msg.sender);
    }

    function _isImmutable(bytes4 selector) internal view returns (bool) {
        return DiamondIncrementalBehavior.isImmutable(selector);
    }
}
