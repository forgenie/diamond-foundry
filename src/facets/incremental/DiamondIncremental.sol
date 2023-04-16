// SPDX-License-Identifier MIT License
pragma solidity 0.8.19;

import { IDiamondIncremental } from "./IDiamondIncremental.sol";
import { DiamondIncrementalBehavior } from "./DiamondIncrementalBehavior.sol";

abstract contract DiamondIncremental is IDiamondIncremental {
    /// @inheritdoc IDiamondIncremental
    function turnImmutable(bytes4 selector) public {
        _authorizeImmute();

        DiamondIncrementalBehavior.turnImmutable(selector);
    }

    /// @inheritdoc IDiamondIncremental
    function isImmutable(bytes4 selector) public view returns (bool) {
        return DiamondIncrementalBehavior.isImmutable(selector);
    }

    function _authorizeImmute() internal virtual;
}
