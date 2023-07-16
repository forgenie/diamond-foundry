// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { Facet } from "src/facets/Facet.sol";
import { IDiamondIncremental } from "./IDiamondIncremental.sol";
import { DiamondIncrementalBase } from "./DiamondIncrementalBase.sol";

// todo: inherit diamondCutBase
contract DiamondIncrementalFacet is IDiamondIncremental, DiamondIncrementalBase, Facet {
    function DiamondIncremental_init() external onlyInitializing {
        _addInterface(type(IDiamondIncremental).interfaceId);
    }

    /// @inheritdoc IDiamondIncremental
    function turnImmutable(bytes4 selector) external protected {
        _turnImmutable(selector);
    }

    /// @inheritdoc IDiamondIncremental
    function isImmutable(bytes4 selector) external view returns (bool) {
        return _isImmutable(selector);
    }
}
