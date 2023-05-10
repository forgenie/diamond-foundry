// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { BaseTest } from "../Base.t.sol";
import { IFacetRegistry, FacetRegistry } from "src/registry/FacetRegistry.sol";
import { IDiamondFactoryStructs } from "src/factory/IDiamondFactory.sol";
import { DiamondFactory } from "src/factory/DiamondFactory.sol";

abstract contract DiamondFactoryTest is IDiamondFactoryStructs, BaseTest {
    DiamondFactory public diamondFactory;
    FacetRegistry public facetRegistry;

    function setUp() public virtual override {
        super.setUp();

        facetRegistry = new FacetRegistry();
        diamondFactory = new DiamondFactory(facetRegistry);
    }
}
