// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { FacetRegistryTest } from "../FacetRegistry.t.sol";

contract FacetRegistry_removeFacet is FacetRegistryTest {
    function test_RevertsWhen_FacetNotRegistered() public {
        vm.expectRevert(FacetRegistry_FacetNotRegistered.selector);

        facetRegistry.removeFacet(address(1));
    }

    function test_RemovesFacet() public {
        bytes4[] memory selectors = mockFacetHelper.selectors();

        facetRegistry.addFacet(mockFacet, selectors);

        vm.expectEmit(address(facetRegistry));
        emit FacetUnregistered(mockFacet);

        facetRegistry.removeFacet(mockFacet);

        address[] memory facetAddresses = facetRegistry.facetAddresses();
        for (uint256 i = 0; i < facetAddresses.length; i++) {
            assertNotEq(facetAddresses[i], mockFacet);
        }
        bytes4[] memory facetSelectors = facetRegistry.facetSelectors(mockFacet);
        assertEq(facetSelectors.length, 0);
    }
}
