// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { BaseTest } from "../Base.t.sol";
import { IFacetRegistry, FacetRegistry } from "src/registry/FacetRegistry.sol";
import { IDiamondFoundryStructs } from "src/factory/IDiamondFoundry.sol";
import { DiamondFoundry } from "src/factory/DiamondFoundry.sol";
import { Diamond } from "src/Diamond.sol";

abstract contract DiamondFoundryTest is IDiamondFoundryStructs, BaseTest {
    DiamondFoundry public diamondFactory;
    FacetRegistry public facetRegistry;

    function setUp() public virtual override {
        super.setUp();

        facetRegistry = new FacetRegistry();
        diamondFactory = new DiamondFoundry(facetRegistry, address(0));
    }
}
