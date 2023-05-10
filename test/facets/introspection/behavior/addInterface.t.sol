// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IntrospectionBaseTest } from "../introspection.t.sol";
import { Introspection_addInteface_AlreadySupported } from "src/facets/introspection/IntrospectionBehavior.sol";
import { IMockFacet } from "test/mocks/MockFacet.sol";

contract IntrospectionBase_addInterface is IntrospectionBaseTest {
    function test_RevertsWhen_AlreadySupported() public {
        _addInterface(type(IMockFacet).interfaceId);

        vm.expectRevert(abi.encodeWithSelector(Introspection_addInteface_AlreadySupported.selector));

        _addInterface(type(IMockFacet).interfaceId);
    }

    function test_AddsInterface() public {
        _addInterface(type(IMockFacet).interfaceId);

        assertTrue(_supportsInterface(type(IMockFacet).interfaceId));
    }
}
