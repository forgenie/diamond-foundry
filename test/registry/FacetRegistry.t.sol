// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { BaseTest } from "../Base.t.sol";

import { FacetRegistry } from "src/registry/FacetRegistry.sol";

abstract contract FacetRegistryTest is BaseTest {
    FacetRegistry public facetRegistry;

    event FacetImplementationSet(bytes32 indexed facetId, address indexed facet);

    function setUp() public virtual override {
        super.setUp();

        facetRegistry = new FacetRegistry();
    }
}
