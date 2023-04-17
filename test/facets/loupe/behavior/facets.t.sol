// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { DiamondLoupeBehaviorTest } from "../loupe.t.sol";
import { DiamondCutBehavior } from "src/facets/cut/DiamondCutBehavior.sol";
import { DiamondLoupeBehavior } from "src/facets/loupe/DiamondLoupeBehavior.sol";
import { MockFacetHelper } from "test/mocks/MockFacet.sol";
import { IDiamondLoupe } from "src/facets/loupe/IDiamondLoupe.sol";

contract DiamondLoupe_facets is DiamondLoupeBehaviorTest {
    function test_OnAdd_ReturnsCorrectly() public appendFacets(mockFacet()) {
        for (uint256 i = 0; i < facets.length; i++) {
            facet = facets[i];

            DiamondCutBehavior.addFacet(facet.facet(), facet.selectors());
        }

        IDiamondLoupe.Facet[] memory loupeFacets = DiamondLoupeBehavior.facets();

        assertEq(loupeFacets.length, facets.length);
        for (uint256 i = 0; i < facets.length; i++) {
            address expectedFacet = facets[i].facet();
            bytes4[] memory expectedSelectors = facets[i].selectors();

            assertEq(loupeFacets[i].facetAddress, expectedFacet);
            for (uint256 j = 0; j < expectedSelectors.length; j++) {
                assertEq(loupeFacets[i].functionSelectors[j], expectedSelectors[j]);
            }
        }
    }

    function test_OnRemove_ReturnsCorrectly() public appendFacets(mockFacet()) {
        for (uint256 i = 0; i < facets.length; i++) {
            facet = facets[i];

            DiamondCutBehavior.addFacet(facet.facet(), facet.selectors());
            DiamondCutBehavior.removeFacet(facet.facet(), facet.selectors());
        }

        IDiamondLoupe.Facet[] memory loupeFacets = DiamondLoupeBehavior.facets();

        assertEq(loupeFacets.length, 0);
    }

    function test_OnReplace_ReturnsCorrectly() public appendFacets(mockFacet()) {
        MockFacetHelper newFacet = new MockFacetHelper();
        for (uint256 i = 0; i < facets.length; i++) {
            facet = facets[i];

            DiamondCutBehavior.addFacet(facet.facet(), facet.selectors());
            DiamondCutBehavior.replaceFacet(newFacet.facet(), newFacet.selectors());
        }

        IDiamondLoupe.Facet[] memory loupeFacets = DiamondLoupeBehavior.facets();

        assertEq(loupeFacets.length, facets.length);
        for (uint256 i = 0; i < facets.length; i++) {
            address expectedFacet = newFacet.facet();
            bytes4[] memory expectedSelectors = newFacet.selectors();

            assertEq(loupeFacets[i].facetAddress, expectedFacet);
            for (uint256 j = 0; j < expectedSelectors.length; j++) {
                assertEq(loupeFacets[i].functionSelectors[j], expectedSelectors[j]);
            }
        }
    }
}
