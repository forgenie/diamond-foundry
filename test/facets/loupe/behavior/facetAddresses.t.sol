// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { DiamondLoupeBaseTest } from "../loupe.t.sol";
import { MockFacet } from "test/mocks/MockFacet.sol";

contract DiamondLoupeBase_facetAddresses is DiamondLoupeBaseTest {
    function test_OnAdd_ReturnsCorrectly() public appendFacets(mockFacet()) {
        for (uint256 i = 0; i < facets.length; i++) {
            facet = facets[i];

            _addFacet(facet.facet(), facet.selectors());
        }

        address[] memory facetAddresses = _facetAddresses();

        assertEq(facetAddresses.length, facets.length);
        for (uint256 i = 0; i < facetAddresses.length; i++) {
            address expectedFacet = facets[i].facet();

            assertEq(expectedFacet, facetAddresses[i]);
        }
    }

    function test_OnRemove_ReturnsCorrectly() public appendFacets(mockFacet()) {
        for (uint256 i = 0; i < facets.length; i++) {
            facet = facets[i];

            _addFacet(facet.facet(), facet.selectors());
            _removeFacet(facet.facet(), facet.selectors());
        }

        address[] memory facetAddresses = _facetAddresses();

        assertEq(facetAddresses.length, 0);
    }

    function test_OnReplace_ReturnsCorrectly() public appendFacets(mockFacet()) {
        address newFacet = address(new MockFacet());

        for (uint256 i = 0; i < facets.length; i++) {
            facet = facets[i];

            _addFacet(facet.facet(), facet.selectors());
            _replaceFacet(newFacet, facet.selectors());
        }

        address[] memory facetAddresses = _facetAddresses();

        assertContains(facetAddresses, newFacet);
        for (uint256 i = 0; i < facetAddresses.length; i++) {
            facet = facets[i];
            assertNotEq(facetAddresses[i], facet.facet());
        }
    }
}
