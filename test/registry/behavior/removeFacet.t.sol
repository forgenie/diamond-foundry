// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { FacetRegistryTest } from "../FacetRegistry.t.sol";

contract FacetRegistry_removeFacet is FacetRegistryTest {
    function test_RevertsWhen_FacetNotRegistered() public {
        vm.expectRevert(FacetRegistry_FacetNotRegistered.selector);

        facetRegistry.removeFacet(address(1));
    }

    function test_RemovesFacet() public {
        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = mockFacet.mockFunction.selector;
        address facet = address(mockFacet);

        facetRegistry.addFacet(facet, selectors);

        vm.expectEmit(address(facetRegistry));
        emit FacetUnregistered(facet);

        facetRegistry.removeFacet(facet);

        address[] memory facetAddresses = facetRegistry.facetAddresses();
        for (uint256 i = 0; i < facetAddresses.length; i++) {
            assertNotEq(facetAddresses[i], facet);
        }
        bytes4[] memory facetSelectors = facetRegistry.facetSelectors(facet);
        assertEq(facetSelectors.length, 0);
    }
}
