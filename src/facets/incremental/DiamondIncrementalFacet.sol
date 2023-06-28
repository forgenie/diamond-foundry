// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Auth } from "src/auth/Auth.sol";
import { Facet } from "src/facets/Facet.sol";
import { IDiamondIncremental } from "./IDiamondIncremental.sol";
import { DiamondIncrementalBase } from "./DiamondIncrementalBase.sol";

// todo: inherit diamondCutBase
contract DiamondIncrementalFacet is IDiamondIncremental, DiamondIncrementalBase, Facet, Auth {
    function initialize() external onlyInitializing {
        __DiamondIncremental_init();
    }

    /// @inheritdoc IDiamondIncremental
    function turnImmutable(bytes4 selector) external onlyOwner {
        _turnImmutable(selector);
    }

    /// @inheritdoc IDiamondIncremental
    function isImmutable(bytes4 selector) external view returns (bool) {
        return _isImmutable(selector);
    }
}
