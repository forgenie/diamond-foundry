// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamondIncremental } from "./IDiamondIncremental.sol";
import { DiamondIncrementalBehavior } from "./DiamondIncrementalBehavior.sol";
import { Facet } from "src/facets/Facet.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";
import { OwnableBehavior } from "src/facets/ownable/OwnableBehavior.sol";

contract DiamondIncrementalFacet is IDiamondIncremental, Facet {
    function __DiamondIncremental_init() internal onlyInitializing {
        IntrospectionBehavior.addInterface(type(IDiamondIncremental).interfaceId);
    }

    function initialize() external initializer {
        __DiamondIncremental_init();
    }

    /// @inheritdoc IDiamondIncremental
    function turnImmutable(bytes4 selector) public {
        _authorizeImmute();

        DiamondIncrementalBehavior.turnImmutable(selector);
    }

    /// @inheritdoc IDiamondIncremental
    function isImmutable(bytes4 selector) public view returns (bool) {
        return DiamondIncrementalBehavior.isImmutable(selector);
    }

    function _authorizeImmute() internal virtual {
        OwnableBehavior.checkOwner(_msgSender());
    }
}
