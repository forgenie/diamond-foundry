// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import { DiamondLoupeFacetTest } from "../loupe.t.sol";
import { MockFacetHelper } from "test/mocks/MockFacet.t.sol";

contract DiamondLoupe_facetSelectors is DiamondLoupeFacetTest {
    function test_OnAdd_ReturnsCorrectly() public multiFacetTest(mockFacet()) {
        addFacet(facet);

        bytes4[] memory selectors = diamondLoupe.facetFunctionSelectors(facet.facet());

        assertEq(selectors.length, facet.selectors().length);
        for (uint256 i = 0; i < selectors.length; i++) {
            assertEq(selectors[i], facet.selectors()[i]);
        }
    }

    function test_OnRemove_ReturnsCorrectly() public multiFacetTest(mockFacet()) {
        addFacet(facet);
        removeFacet(facet);

        bytes4[] memory selectors = diamondLoupe.facetFunctionSelectors(facet.facet());

        assertEq(selectors.length, 0);
    }

    function test_OnReplace_ReturnsCorrectly() public multiFacetTest(mockFacet()) {
        MockFacetHelper newFacet = new MockFacetHelper();
        addFacet(facet);
        replaceFacet(newFacet);

        bytes4[] memory selectors = diamondLoupe.facetFunctionSelectors(newFacet.facet());

        assertEq(selectors.length, facet.selectors().length);
        for (uint256 i = 0; i < selectors.length; i++) {
            assertEq(selectors[i], facet.selectors()[i]);
        }
    }
}
