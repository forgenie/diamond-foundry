// SPDX-License-Identifier MIT License
pragma solidity 0.8.19;

import { IDiamondIncremental } from "./IDiamondIncremental.sol";
import { DiamondIncrementalBehavior } from "./DiamondIncrementalBehavior.sol";

abstract contract DiamondIncremental is IDiamondIncremental {
    /// @inheritdoc IDiamondIncremental
    function immute(bytes4[] memory selectors) public {
        authorizeImmute();
        DiamondIncrementalBehavior.immute(selectors);
    }

    /// @inheritdoc IDiamondIncremental
    function isImmutable(bytes4 selector) public view returns (bool) {
        return DiamondIncrementalBehavior.isImmutable(selector);
    }

    function authorizeImmute() internal virtual;
}
