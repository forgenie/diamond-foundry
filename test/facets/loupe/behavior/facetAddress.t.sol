// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { DiamondLoupeFacetTest } from "../loupe.t.sol";
import { MockFacet, MockFacetHelper } from "test/mocks/MockFacet.t.sol";

contract DiamondLoupe_facetAddress is DiamondLoupeFacetTest {
    function test_OnAdd_ReturnsCorrectly() public multiFacetTest(mockFacet()) {
        bytes4[] memory expectedSelectors = facet.selectors();
        address expectedFacetAddress = facet.facet();

        addFacet(facet);

        for (uint256 i = 0; i < expectedSelectors.length; i++) {
            address facetAddress = diamondLoupe.facetAddress(expectedSelectors[i]);

            assertEq(facetAddress, expectedFacetAddress);
        }
    }

    function test_OnRemove_ReturnsCorrectly() public multiFacetTest(mockFacet()) {
        bytes4[] memory expectedSelectors = facet.selectors();

        addFacet(facet);
        removeFacet(facet);

        for (uint256 i = 0; i < expectedSelectors.length; i++) {
            address facetAddress = diamondLoupe.facetAddress(expectedSelectors[i]);

            assertEq(facetAddress, address(0));
        }
    }

    function test_OnReplace_ReturnsCorrectly() public multiFacetTest(mockFacet()) {
        bytes4[] memory expectedSelectors = facet.selectors();

        addFacet(facet);
        MockFacetHelper mockHelper = new MockFacetHelper();
        replaceFacet(mockHelper);

        for (uint256 i = 0; i < expectedSelectors.length; i++) {
            address facetAddress = diamondLoupe.facetAddress(expectedSelectors[i]);

            assertEq(facetAddress, mockHelper.facet());
        }
    }
}
