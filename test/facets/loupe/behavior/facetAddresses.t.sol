// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import { DiamondLoupeFacetTest } from "../loupe.t.sol";
import { MockFacet, MockFacetHelper } from "test/mocks/MockFacet.t.sol";

contract DiamondLoupe_facetAddresses is DiamondLoupeFacetTest {
    function test_OnAdd_ReturnsCorrectly() public appendFacets(mockFacet()) {
        address[] memory facetAddressesBefore = diamondLoupe.facetAddresses();
        for (uint256 i = 0; i < facets.length; i++) {
            addFacet(facets[i]);
        }
        address[] memory facetAddressesNow = diamondLoupe.facetAddresses();

        assertEq(facetAddressesNow.length - facetAddressesBefore.length, facets.length);
        for (uint256 i = 0; i < facets.length; i++) {
            assertContains(facetAddressesNow, facets[i].facet());
        }
    }

    function test_OnRemove_ReturnsCorrectly() public appendFacets(mockFacet()) {
        address[] memory facetAddressesBefore = diamondLoupe.facetAddresses();
        for (uint256 i = 0; i < facets.length; i++) {
            addFacet(facets[i]);
            removeFacet(facets[i]);
        }
        address[] memory facetAddressesNow = diamondLoupe.facetAddresses();

        assertEq(facetAddressesNow.length, facetAddressesBefore.length);
    }

    function test_OnReplace_ReturnsCorrectly() public multiFacetTest(mockFacet()) {
        MockFacetHelper newFacet = new MockFacetHelper();
        addFacet(facet);
        replaceFacet(newFacet);

        address[] memory facetAddresses = diamondLoupe.facetAddresses();

        assertContains(facetAddresses, newFacet.facet());
        for (uint256 i = 0; i < facetAddresses.length; i++) {
            assertNotEq(facetAddresses[i], facet.facet());
        }
    }
}
