// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IFacetRegistry } from "src/registry/IFacetRegistry.sol";
import { FacetRegistryTest } from "../FacetRegistry.t.sol";
import { FacetRegistry_removeFacet_FacetNotRegistered } from "src/registry/Errors.sol";

// solhint-disable-next-line contract-name-camelcase
contract FacetRegistry_removeFacet is FacetRegistryTest {
    function test_RevertsWhen_FacetNotRegistered() public {
        bytes32 facetId = facetRegistry.computeFacetId("UnexistentFacet");

        vm.expectRevert(FacetRegistry_removeFacet_FacetNotRegistered.selector);

        facetRegistry.removeFacet(facetId);
    }

    function test_RemovesFacet() public {
        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = mockFacet.mockFunction.selector;
        string memory facetName = "MockFacet";

        IFacetRegistry.FacetInfo memory facetInfo = IFacetRegistry.FacetInfo({
            addr: address(mockFacet),
            name: facetName,
            initializer: bytes4(0x01020304),
            selectors: selectors
        });

        bytes32 facetId = facetRegistry.computeFacetId(facetName);

        facetRegistry.registerFacet(facetInfo);

        expectEmit(address(facetRegistry));
        emit FacetImplementationSet(facetId, address(0));

        facetRegistry.removeFacet(facetId);

        assertEq(facetRegistry.getFacetId(address(mockFacet)), bytes32(0));
        assertEq(facetRegistry.getFacetAddress(facetId), address(0));
        assertEq(facetRegistry.getInitializer(facetId), bytes4(0));
        assertEq(facetRegistry.getFacetInterface(facetId), bytes4(0));
        // assertEq(facetRegistry.getFacetSelectors(facetId), new bytes4[](0));
    }
}
