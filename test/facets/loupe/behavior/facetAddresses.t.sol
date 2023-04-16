// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { DiamondLoupeBehaviorTest } from "../loupe.t.sol";
import { DiamondCutBehavior } from "src/facets/cut/DiamondCutBehavior.sol";
import { DiamondLoupeBehavior } from "src/facets/loupe/DiamondLoupeBehavior.sol";
import { MockFacet } from "test/mocks/MockFacet.sol";

contract DiamondLoupe_facetAddresses is DiamondLoupeBehaviorTest {
    function test_OnAdd_ReturnsCorrectly() public multiFacetTest(mockFacet()) {
        DiamondCutBehavior.addFacet(facet.facet(), facet.selectors());

        address[] memory facetAddresses = DiamondLoupeBehavior.facetAddresses();

        assertContains(facetAddresses, facet.facet());
    }

    function test_onRemove_ReturnsCorrectly() public multiFacetTest(mockFacet()) {
        DiamondCutBehavior.addFacet(facet.facet(), facet.selectors());

        DiamondCutBehavior.removeFacet(facet.facet(), facet.selectors());

        address[] memory facetAddresses = DiamondLoupeBehavior.facetAddresses();

        assertEq(facetAddresses.length, 0);
    }

    function test_onReplace_ReturnsCorrectly() public multiFacetTest(mockFacet()) {
        DiamondCutBehavior.addFacet(facet.facet(), facet.selectors());

        MockFacet newFacet = new MockFacet();
        DiamondCutBehavior.replaceFacet(address(newFacet), facet.selectors());

        address[] memory facetAddresses = DiamondLoupeBehavior.facetAddresses();

        assertContains(facetAddresses, address(newFacet));

        for (uint256 i = 0; i < facetAddresses.length; i++) {
            assertNotEq(facetAddresses[i], facet.facet());
        }
    }
}
