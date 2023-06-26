// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IFacetRegistry, FacetRegistry_FacetNotRegistered } from "src/registry/FacetRegistry.sol";
import { FacetRegistryTest } from "../FacetRegistry.t.sol";

// solhint-disable-next-line contract-name-camelcase
contract FacetRegistry_removeFacet is FacetRegistryTest {
    function test_RevertsWhen_FacetNotRegistered() public {
        bytes32 facetId = facetRegistry.computeFacetId(address(mockFacet));

        vm.expectRevert(FacetRegistry_FacetNotRegistered.selector);

        facetRegistry.removeFacet(facetId);
    }

    function test_RemovesFacet() public {
        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = mockFacet.mockFunction.selector;

        IFacetRegistry.FacetInfo memory facetInfo = IFacetRegistry.FacetInfo({
            addr: address(mockFacet),
            initializer: bytes4(0x01020304),
            selectors: selectors
        });

        bytes32 facetId = facetRegistry.computeFacetId(address(mockFacet));

        facetRegistry.registerFacet(facetInfo);

        vm.expectEmit(address(facetRegistry));
        emit FacetImplementationSet(facetId, address(0));

        facetRegistry.removeFacet(facetId);

        assertEq(facetRegistry.facetAddress(facetId), address(0));
        assertEq(facetRegistry.initializer(facetId), bytes4(0));
        assertEq(facetRegistry.facetInterface(facetId), bytes4(0));
        // assertEq(facetRegistry.getFacetSelectors(facetId), new bytes4[](0));
    }
}
