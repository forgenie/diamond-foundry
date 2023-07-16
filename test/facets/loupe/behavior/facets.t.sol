// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { DiamondLoupeBaseTest } from "../loupe.t.sol";
import { MockFacetHelper } from "test/mocks/MockFacet.sol";

contract DiamondLoupeBase_facets is DiamondLoupeBaseTest {
    function test_OnAdd_ReturnsCorrectly() public appendFacets(mockFacet()) {
        for (uint256 i = 0; i < facets.length; i++) {
            facet = facets[i];

            _addFacet(facet.facet(), facet.selectors());
        }

        Facet[] memory loupeFacets = _facets();

        assertEq(loupeFacets.length, facets.length);
        for (uint256 i = 0; i < facets.length; i++) {
            address expectedFacet = facets[i].facet();
            bytes4[] memory expectedSelectors = facets[i].selectors();

            assertEq(loupeFacets[i].facet, expectedFacet);
            for (uint256 j = 0; j < expectedSelectors.length; j++) {
                assertEq(loupeFacets[i].selectors[j], expectedSelectors[j]);
            }
        }
    }

    function test_OnRemove_ReturnsCorrectly() public appendFacets(mockFacet()) {
        for (uint256 i = 0; i < facets.length; i++) {
            facet = facets[i];

            _addFacet(facet.facet(), facet.selectors());
            _removeFacet(facet.facet(), facet.selectors());
        }

        Facet[] memory loupeFacets = _facets();

        assertEq(loupeFacets.length, 0);
    }

    function test_OnReplace_ReturnsCorrectly() public appendFacets(mockFacet()) {
        MockFacetHelper newFacet = new MockFacetHelper();
        for (uint256 i = 0; i < facets.length; i++) {
            facet = facets[i];

            _addFacet(facet.facet(), facet.selectors());
            _replaceFacet(newFacet.facet(), newFacet.selectors());
        }

        Facet[] memory loupeFacets = _facets();

        assertEq(loupeFacets.length, facets.length);
        for (uint256 i = 0; i < facets.length; i++) {
            address expectedFacet = newFacet.facet();
            bytes4[] memory expectedSelectors = newFacet.selectors();

            assertEq(loupeFacets[i].facet, expectedFacet);
            for (uint256 j = 0; j < expectedSelectors.length; j++) {
                assertEq(loupeFacets[i].selectors[j], expectedSelectors[j]);
            }
        }
    }
}
