// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import { DiamondLoupeFacetTest } from "../loupe.t.sol";
import { MockFacetHelper } from "test/mocks/MockFacet.t.sol";

contract DiamondLoupe_facets is DiamondLoupeFacetTest {
    function test_OnAdd_ReturnsCorrectly() public appendFacets(mockFacet()) {
        Facet[] memory loupeFacetsBefore = diamondLoupe.facets();
        for (uint256 i = 0; i < facets.length; i++) {
            addFacet(facets[i]);
        }
        Facet[] memory loupeFacetsNow = diamondLoupe.facets();

        assertEq(loupeFacetsNow.length - loupeFacetsBefore.length, facets.length);
        for (uint256 i = 0; i < facets.length; i++) {
            address expectedFacet = facets[i].facet();
            bytes4[] memory expectedSelectors = facets[i].selectors();

            uint256 addedFacetIndex = loupeFacetsNow.length - 1 - i;
            assertEq(loupeFacetsNow[addedFacetIndex].facet, expectedFacet);
            for (uint256 j = 0; j < expectedSelectors.length; j++) {
                assertEq(loupeFacetsNow[addedFacetIndex].selectors[j], expectedSelectors[j]);
            }
        }
    }

    function test_OnRemove_ReturnsCorrectly() public appendFacets(mockFacet()) {
        Facet[] memory loupeFacetsBefore = diamondLoupe.facets();
        for (uint256 i = 0; i < facets.length; i++) {
            addFacet(facets[i]);
            removeFacet(facets[i]);
        }
        Facet[] memory loupeFacetsNow = diamondLoupe.facets();

        assertEq(loupeFacetsBefore.length, loupeFacetsNow.length);
    }

    function test_OnReplace_ReturnsCorrectly() public appendFacets(mockFacet()) {
        MockFacetHelper newFacet = new MockFacetHelper();
        Facet[] memory loupeFacetsBefore = diamondLoupe.facets();
        for (uint256 i = 0; i < facets.length; i++) {
            addFacet(facets[i]);
            replaceFacet(newFacet);
        }
        Facet[] memory loupeFacetsNow = diamondLoupe.facets();

        assertEq(loupeFacetsNow.length - loupeFacetsBefore.length, facets.length);
        address expectedFacet = newFacet.facet();
        bytes4[] memory expectedSelectors = newFacet.selectors();
        for (uint256 i = 0; i < facets.length; i++) {
            uint256 addedFacetIndex = loupeFacetsNow.length - 1 - i;
            assertEq(loupeFacetsNow[addedFacetIndex].facet, expectedFacet);
            for (uint256 j = 0; j < expectedSelectors.length; j++) {
                assertEq(loupeFacetsNow[addedFacetIndex].selectors[j], expectedSelectors[j]);
            }
        }
    }
}
