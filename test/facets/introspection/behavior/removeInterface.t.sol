// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IntrospectionBehaviorTest } from "../introspection.t.sol";
import {
    IntrospectionBehavior,
    Introspection_removeInterface_AlreadyNotSupported
} from "src/facets/introspection/IntrospectionBehavior.sol";
import { IMockFacet } from "test/mocks/MockFacet.sol";

contract Introspection_remove is IntrospectionBehaviorTest {
    function test_RevertsWhen_DoesNotExist() public {
        vm.expectRevert(abi.encodeWithSelector(Introspection_removeInterface_AlreadyNotSupported.selector));

        IntrospectionBehavior.removeInterface(type(IMockFacet).interfaceId);
    }

    function test_RemovesInterface() public {
        IntrospectionBehavior.addInterface(type(IMockFacet).interfaceId);
        IntrospectionBehavior.removeInterface(type(IMockFacet).interfaceId);

        assertFalse(IntrospectionBehavior.supportsInterface(type(IMockFacet).interfaceId));
    }
}
