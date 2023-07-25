// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { BaseTest } from "../Base.t.sol";
import { MockFacetHelper } from "test/mocks/MockFacet.sol";
import { FacetRegistry } from "src/registry/FacetRegistry.sol";
import { IFacetRegistryBase } from "src/registry/IFacetRegistryBase.sol";

abstract contract FacetRegistryTest is IFacetRegistryBase, BaseTest {
    FacetRegistry public facetRegistry;
    MockFacetHelper public mockFacetHelper;
    address public mockFacet;

    event FacetImplementationSet(bytes32 indexed facetId, address indexed facet);

    function setUp() public virtual override {
        super.setUp();

        facetRegistry = new FacetRegistry();
        mockFacetHelper = new MockFacetHelper();
        mockFacet = mockFacetHelper.facet();
    }
}
