// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamondBase } from "./IDiamondBase.sol";
import { BaseFacet } from "src/facets/BaseFacet.sol";
import { DiamondIncrementalFacet } from "src/facets/incremental/DiamondIncrementalFacet.sol";
import { DiamondCutFacet } from "src/facets/cut/DiamondCutFacet.sol";
import { DiamondLoupeFacet } from "src/facets/loupe/DiamondLoupeFacet.sol";
import { OwnableFacet, OwnableBehavior } from "src/facets/ownable/OwnableFacet.sol";
import { IntrospectionFacet, IntrospectionBehavior } from "src/facets/introspection/IntrospectionFacet.sol";

contract DiamondBaseFacet is
    IDiamondBase,
    BaseFacet,
    DiamondCutFacet,
    DiamondLoupeFacet,
    OwnableFacet,
    IntrospectionFacet,
    DiamondIncrementalFacet
{
    function initialize(address owner_) external initializer {
        __DiamondCut_init();
        __DiamondLoupe_init();
        __Ownable_init(owner_);
        __Introspection_init();
        __DiamondIncremental_init();
    }

    function _authorizeDiamondCut() internal override {
        OwnableBehavior.checkOwner(_msgSender());
    }

    function _authorizeImmute() internal override {
        OwnableBehavior.checkOwner(_msgSender());
    }
}
