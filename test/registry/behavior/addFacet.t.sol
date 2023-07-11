// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { FacetRegistryTest } from "../FacetRegistry.t.sol";

contract FacetRegistry_addFacet is FacetRegistryTest {
    function test_RevertsWhen_FacetAddressIsZero() public {
        vm.expectRevert(FacetRegistry_FacetAddressZero.selector);

        facetRegistry.addFacet(address(0), new bytes4[](1));
    }

    function test_RevertsWhen_SelectorArrayEmpty() public {
        vm.expectRevert(FacetRegistry_FacetMustHaveSelectors.selector);

        facetRegistry.addFacet(address(mockFacet), new bytes4[](0));
    }

    function test_RevertsWhen_FacetIsNotContract() public {
        vm.expectRevert(FacetRegistry_FacetNotContract.selector);

        facetRegistry.addFacet(address(1), new bytes4[](1));
    }

    function test_RevertsWhen_FacetAlreadyRegistered() public {
        facetRegistry.addFacet(address(mockFacet), new bytes4[](1));

        vm.expectRevert(FacetRegistry_FacetAlreadyRegistered.selector);

        facetRegistry.addFacet(address(mockFacet), new bytes4[](1));
    }

    function test_RegistersFacet() public {
        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = mockFacet.mockFunction.selector;
        address facet = address(mockFacet);

        vm.expectEmit(address(facetRegistry));
        emit FacetRegistered(facet, selectors);

        facetRegistry.addFacet(facet, selectors);

        assertContains(facetRegistry.facetAddresses(), facet);
        bytes4[] memory facetSelectors = facetRegistry.facetSelectors(facet);
        for (uint256 i = 0; i < selectors.length; i++) {
            assertEq(facetSelectors[i], selectors[i]);
        }
    }
}
