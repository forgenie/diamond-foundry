// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { DiamondLoupeBaseTest } from "../loupe.t.sol";
import { MockFacet } from "test/mocks/MockFacet.sol";

contract DiamondLoupeBase_facetSelectors is DiamondLoupeBaseTest {
    function test_OnAdd_ReturnsCorrectly() public multiFacetTest(mockFacet()) {
        _addFacet(facet.facet(), facet.selectors());

        bytes4[] memory selectors = _facetSelectors(facet.facet());

        assertEq(selectors.length, facet.selectors().length);
        for (uint256 i = 0; i < selectors.length; i++) {
            assertEq(selectors[i], facet.selectors()[i]);
        }
    }

    function test_OnRemove_ReturnsCorrectly() public multiFacetTest(mockFacet()) {
        _addFacet(facet.facet(), facet.selectors());
        _removeFacet(facet.facet(), facet.selectors());

        bytes4[] memory selectors = _facetSelectors(facet.facet());

        assertEq(selectors.length, 0);
    }

    function test_OnReplace_ReturnsCorrectly() public multiFacetTest(mockFacet()) {
        _addFacet(facet.facet(), facet.selectors());
        address newFacet = address(new MockFacet());
        _replaceFacet(newFacet, facet.selectors());

        bytes4[] memory selectors = _facetSelectors(newFacet);

        assertEq(selectors.length, facet.selectors().length);
        for (uint256 i = 0; i < selectors.length; i++) {
            assertEq(selectors[i], facet.selectors()[i]);
        }
    }
}
