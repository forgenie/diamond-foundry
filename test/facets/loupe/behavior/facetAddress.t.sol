// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { DiamondLoupeBaseTest } from "../loupe.t.sol";
import { MockFacet } from "test/mocks/MockFacet.sol";

contract DiamondLoupeBase_facetAddress is DiamondLoupeBaseTest {
    function test_OnAdd_ReturnsCorrectly() public multiFacetTest(mockFacet()) {
        bytes4[] memory expectedSelectors = facet.selectors();
        address expectedFacetAddress = facet.facet();

        _addFacet(expectedFacetAddress, expectedSelectors);

        for (uint256 i = 0; i < expectedSelectors.length; i++) {
            address facetAddress = _facetAddress(expectedSelectors[i]);

            assertEq(facetAddress, expectedFacetAddress);
        }
    }

    function test_OnRemove_ReturnsCorrectly() public multiFacetTest(mockFacet()) {
        bytes4[] memory expectedSelectors = facet.selectors();
        address expectedFacetAddress = facet.facet();

        _addFacet(expectedFacetAddress, expectedSelectors);
        _removeFacet(expectedFacetAddress, expectedSelectors);

        for (uint256 i = 0; i < expectedSelectors.length; i++) {
            address facetAddress = _facetAddress(expectedSelectors[i]);

            assertEq(facetAddress, address(0));
        }
    }

    function test_OnReplace_ReturnsCorrectly() public multiFacetTest(mockFacet()) {
        bytes4[] memory expectedSelectors = facet.selectors();
        address oldFacet = facet.facet();

        _addFacet(oldFacet, expectedSelectors);
        address expectedFacet = address(new MockFacet());
        _replaceFacet(expectedFacet, expectedSelectors);

        for (uint256 i = 0; i < expectedSelectors.length; i++) {
            address facetAddress = _facetAddress(expectedSelectors[i]);

            assertEq(facetAddress, expectedFacet);
        }
    }
}
