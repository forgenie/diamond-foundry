// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamondBase } from "./IDiamondBase.sol";
import { BaseFacet } from "src/facets/BaseFacet.sol";
import { DiamondIncremental } from "src/facets/incremental/DiamondIncremental.sol";
import { DiamondCut } from "src/facets/cut/DiamondCut.sol";
import { DiamondLoupe } from "src/facets/loupe/DiamondLoupe.sol";
import { Ownable, OwnableBehavior } from "src/facets/ownable/Ownable.sol";
import { Introspection, IntrospectionBehavior } from "src/facets/introspection/Introspection.sol";

contract DiamondBaseFacet is
    IDiamondBase,
    BaseFacet,
    DiamondCut,
    DiamondLoupe,
    Ownable,
    Introspection,
    DiamondIncremental
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
