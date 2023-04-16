// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IntrospectionBehaviorTest } from "../introspection.t.sol";
import {
    IntrospectionBehavior,
    Introspection_addInteface_AlreadySupported
} from "src/facets/introspection/IntrospectionBehavior.sol";
import { IMockFacet } from "test/mocks/MockFacet.sol";

contract Introspection_addInterface is IntrospectionBehaviorTest {
    function test_RevertsWhen_AlreadySupported() public {
        vm.expectRevert(abi.encodeWithSelector(Introspection_addInteface_AlreadySupported.selector));

        IntrospectionBehavior.addInterface(type(IMockFacet).interfaceId);
        IntrospectionBehavior.addInterface(type(IMockFacet).interfaceId);
    }

    function test_AddsInterface() public {
        IntrospectionBehavior.addInterface(type(IMockFacet).interfaceId);

        assertTrue(IntrospectionBehavior.supportsInterface(type(IMockFacet).interfaceId));
    }
}
