// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { FacetHelper } from "test/facets/Helpers.t.sol";
import { MockFacetHelper } from "test/mocks/MockFacet.sol";
import { BaseTest } from "test/Base.t.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";
import { IDiamondCut } from "src/facets/cut/IDiamondCut.sol";

abstract contract DiamondLoupeBehaviorTest is BaseTest {
    FacetHelper[] public facets;
    FacetHelper public facet;

    modifier multiFacetTest(FacetHelper[] memory testFacets) {
        for (uint256 i = 0; i < testFacets.length; i++) {
            facet = testFacets[i];
            _;
        }
    }

    modifier appendFacets(FacetHelper[] memory testFacets) {
        delete facets;
        for (uint256 i = 0; i < testFacets.length; i++) {
            facets.push(testFacets[i]);
        }
        _;
    }

    function setUp() public virtual override {
        super.setUp();

        IntrospectionBehavior.addInterface(type(IDiamondCut).interfaceId);
    }

    function mockFacet() internal returns (FacetHelper[] memory) {
        delete facets;
        facets.push(new MockFacetHelper());
        return facets;
    }
}
