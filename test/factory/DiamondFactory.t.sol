// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { BaseTest } from "../Base.t.sol";
import { IFacetRegistry, FacetRegistry } from "src/registry/FacetRegistry.sol";
import { DiamondFactory } from "src/factory/DiamondFactory.sol";
import { DiamondBaseFacet } from "src/facets/base/DiamondBaseFacet.sol";

import { DiamondBaseFacetHelper } from "test/facets/base/DiamondBase.t.sol";

abstract contract DiamondFactoryTest is BaseTest {
    DiamondFactory public diamondFactory;
    FacetRegistry public facetRegistry;
    DiamondBaseFacetHelper public diamondBase;

    bytes32 public baseFacetId;

    function setUp() public virtual override {
        super.setUp();

        facetRegistry = new FacetRegistry();
        diamondBase = new DiamondBaseFacetHelper();
        baseFacetId = facetRegistry.computeFacetId(diamondBase.name());

        facetRegistry.registerFacet(diamondBase.facetInfo());

        diamondFactory = new DiamondFactory(facetRegistry);
    }
}
