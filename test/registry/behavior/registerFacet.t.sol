// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IFacetRegistry } from "src/registry/IFacetRegistry.sol";
import { FacetRegistryTest } from "../FacetRegistry.t.sol";
import { IMockFacet } from "test/mocks/MockFacet.sol";

import {
    FacetRegistry_validateFacetInfo_FacetAddressZero,
    FacetRegistry_validateFacetInfo_FacetMustHaveSelectors,
    FacetRegistry_validateFacetInfo_FacetNameEmpty,
    FacetRegistry_registerFacet_FacetAlreadyRegistered
} from "src/registry/Errors.sol";

// solhint-disable-next-line contract-name-camelcase
contract FacetRegistry_registerFacet is FacetRegistryTest {
    function test_RevertsWhen_FacetAddressIsZero() public {
        IFacetRegistry.FacetInfo memory facetInfo = IFacetRegistry.FacetInfo({
            addr: address(0),
            name: "TestFacet",
            initializer: bytes4(0),
            selectors: new bytes4[](0)
        });

        vm.expectRevert(FacetRegistry_validateFacetInfo_FacetAddressZero.selector);
        facetRegistry.registerFacet(facetInfo);
    }

    function test_RevertsWhen_SelectorArrayEmpty() public {
        IFacetRegistry.FacetInfo memory facetInfo = IFacetRegistry.FacetInfo({
            addr: address(0x1),
            name: "TestFacet",
            initializer: bytes4(0),
            selectors: new bytes4[](0)
        });

        vm.expectRevert(FacetRegistry_validateFacetInfo_FacetMustHaveSelectors.selector);
        facetRegistry.registerFacet(facetInfo);
    }

    function test_RevertsWhen_FacetNameEmpty() public {
        IFacetRegistry.FacetInfo memory facetInfo = IFacetRegistry.FacetInfo({
            addr: address(0x1),
            name: "",
            initializer: bytes4(0),
            selectors: new bytes4[](1)
        });

        vm.expectRevert(FacetRegistry_validateFacetInfo_FacetNameEmpty.selector);
        facetRegistry.registerFacet(facetInfo);
    }

    function test_RevertsWhen_FacetAlreadyRegistered() public {
        IFacetRegistry.FacetInfo memory facetInfo = IFacetRegistry.FacetInfo({
            addr: address(0x1),
            name: "TestFacet",
            initializer: bytes4(0),
            selectors: new bytes4[](1)
        });

        facetRegistry.registerFacet(facetInfo);
        vm.expectRevert(FacetRegistry_registerFacet_FacetAlreadyRegistered.selector);
        facetRegistry.registerFacet(facetInfo);
    }

    function test_RegistersFacet() public {
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

        expectEmit(address(facetRegistry));
        emit FacetImplementationSet(facetId, address(mockFacet));

        facetRegistry.registerFacet(facetInfo);

        assertEq(facetRegistry.getFacetAddress(facetId), address(mockFacet));
        assertEq(facetRegistry.getFacetId(address(mockFacet)), facetId);
        assertEq(facetRegistry.getInitializer(facetId), facetInfo.initializer);
        assertEq(facetRegistry.getFacetInterface(facetId), type(IMockFacet).interfaceId);
        // assertEq(facetRegistry.getFacetSelectors(facetId), selectors);
    }
}
