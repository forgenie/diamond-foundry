// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IntrospectionBaseTest } from "../introspection.t.sol";
import { Introspection_AlreadyNotSupported } from "src/facets/introspection/IntrospectionBehavior.sol";
import { IMockFacet } from "test/mocks/MockFacet.sol";

contract IntrospectionBase_remove is IntrospectionBaseTest {
    function test_RevertsWhen_DoesNotExist() public {
        vm.expectRevert(abi.encodeWithSelector(Introspection_AlreadyNotSupported.selector));

        _removeInterface(type(IMockFacet).interfaceId);
    }

    function test_RemovesInterface() public {
        _addInterface(type(IMockFacet).interfaceId);
        _removeInterface(type(IMockFacet).interfaceId);

        assertFalse(_supportsInterface(type(IMockFacet).interfaceId));
    }
}
