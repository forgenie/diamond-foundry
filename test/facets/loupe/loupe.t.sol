// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { BaseTest } from "test/Base.t.sol";
import { FacetHelper } from "test/facets/Facet.t.sol";
import { MockFacetHelper } from "test/mocks/MockFacet.sol";
import { DiamondLoupeBase } from "src/facets/loupe/DiamondLoupeBase.sol";

abstract contract DiamondLoupeBaseTest is DiamondLoupeBase, BaseTest {
    /// @dev shortcut for multiFacetTest
    FacetHelper public facet;
    FacetHelper[] public facets;

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

        __DiamondLoupe_init();
    }

    function mockFacet() internal returns (FacetHelper[] memory) {
        delete facets;
        facets.push(new MockFacetHelper());
        return facets;
    }
}
