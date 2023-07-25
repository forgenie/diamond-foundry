// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { FacetRegistryTest } from "../FacetRegistry.t.sol";

contract FacetRegistry_deployFacet is FacetRegistryTest {
    function test_DeploysNewFacet() public {
        bytes4[] memory selectors = mockFacetHelper.selectors();
        address mockFacet = facetRegistry.computeFacetAddress(bytes32(0), mockFacetHelper.creationCode());

        vm.expectEmit(address(facetRegistry));
        emit FacetRegistered(mockFacet, selectors);

        facetRegistry.deployFacet(bytes32(0), mockFacetHelper.creationCode(), selectors);

        assertContains(facetRegistry.facetAddresses(), mockFacet);
        bytes4[] memory facetSelectors = facetRegistry.facetSelectors(mockFacet);
        for (uint256 i = 0; i < selectors.length; i++) {
            assertEq(facetSelectors[i], selectors[i]);
        }
    }
}
