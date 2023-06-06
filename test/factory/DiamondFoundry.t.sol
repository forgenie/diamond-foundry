// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Create2 } from "@openzeppelin/contracts/utils/Create2.sol";
import { BaseTest } from "../Base.t.sol";
import { IFacetRegistry, FacetRegistry } from "src/registry/FacetRegistry.sol";
import { IDiamondFoundryStructs } from "src/IDiamondFoundry.sol";
import { DiamondFoundry } from "src/DiamondFoundry.sol";
import { Diamond } from "src/Diamond.sol";
import { DiamondBase } from "src/diamond/DiamondBase.sol";
import { IDiamondFoundry } from "src/IDiamondFoundry.sol";

abstract contract DiamondFoundryTest is IDiamondFoundryStructs, BaseTest {
    DiamondFoundry public diamondFoundry;
    FacetRegistry public facetRegistry;

    function setUp() public virtual override {
        super.setUp();

        facetRegistry = new FacetRegistry();
        diamondFoundry = new DiamondFoundry(facetRegistry);
    }
}
