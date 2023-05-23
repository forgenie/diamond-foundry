// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {
    IFacetRegistry,
    FacetRegistry_validateFacetInfo_FacetAddressZero,
    FacetRegistry_validateFacetInfo_FacetMustHaveSelectors,
    FacetRegistry_validateFacetInfo_FacetNotContract,
    FacetRegistry_validateFacetInfo_FacetAlreadyRegistered
} from "src/registry/FacetRegistry.sol";
import { FacetRegistryTest } from "../FacetRegistry.t.sol";
import { IMockFacet } from "test/mocks/MockFacet.sol";

// solhint-disable-next-line contract-name-camelcase
contract FacetRegistry_registerFacet is FacetRegistryTest {
    function test_RevertsWhen_FacetAddressIsZero() public {
        IFacetRegistry.FacetInfo memory facetInfo =
            IFacetRegistry.FacetInfo({ addr: address(0), initializer: bytes4(0), selectors: new bytes4[](0) });

        vm.expectRevert(FacetRegistry_validateFacetInfo_FacetAddressZero.selector);
        facetRegistry.registerFacet(facetInfo);
    }

    function test_RevertsWhen_SelectorArrayEmpty() public {
        IFacetRegistry.FacetInfo memory facetInfo =
            IFacetRegistry.FacetInfo({ addr: address(mockFacet), initializer: bytes4(0), selectors: new bytes4[](0) });

        vm.expectRevert(FacetRegistry_validateFacetInfo_FacetMustHaveSelectors.selector);
        facetRegistry.registerFacet(facetInfo);
    }

    function test_RevertsWhen_FacetIsNotContract() public {
        IFacetRegistry.FacetInfo memory facetInfo =
            IFacetRegistry.FacetInfo({ addr: address(0x1), initializer: bytes4(0), selectors: new bytes4[](1) });

        vm.expectRevert(FacetRegistry_validateFacetInfo_FacetNotContract.selector);
        facetRegistry.registerFacet(facetInfo);
    }

    function test_RevertsWhen_FacetAlreadyRegistered() public {
        IFacetRegistry.FacetInfo memory facetInfo =
            IFacetRegistry.FacetInfo({ addr: address(mockFacet), initializer: bytes4(0), selectors: new bytes4[](1) });

        facetRegistry.registerFacet(facetInfo);
        vm.expectRevert(FacetRegistry_validateFacetInfo_FacetAlreadyRegistered.selector);
        facetRegistry.registerFacet(facetInfo);
    }

    function test_RegistersFacet() public {
        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = mockFacet.mockFunction.selector;

        IFacetRegistry.FacetInfo memory facetInfo = IFacetRegistry.FacetInfo({
            addr: address(mockFacet),
            initializer: bytes4(0x01020304),
            selectors: selectors
        });

        bytes32 facetId = facetRegistry.computeFacetId(facetInfo.addr);

        vm.expectEmit(address(facetRegistry));
        emit FacetImplementationSet(facetId, address(mockFacet));

        facetRegistry.registerFacet(facetInfo);

        assertEq(facetRegistry.facetAddress(facetId), address(mockFacet));
        assertEq(facetRegistry.computeFacetId(address(mockFacet)), facetId);
        assertEq(facetRegistry.initializer(facetId), facetInfo.initializer);
        assertEq(facetRegistry.facetInterface(facetId), type(IMockFacet).interfaceId);
        // assertEq(facetRegistry.getFacetSelectors(facetId), selectors);
    }
}
