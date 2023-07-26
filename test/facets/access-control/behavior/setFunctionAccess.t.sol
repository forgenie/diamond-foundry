// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { AccessControlFacetTest } from "../access-control.t.sol";
import { DEFAULT_ADMIN_ROLE } from "src/Constants.sol";

contract AccessControl_setFunctionAccess is AccessControlFacetTest {
    function testFuzz_RevertsWhen_CallerIsUnauthorized(uint8 role, bytes4 selector) public {
        changePrank(users.stranger);
        vm.expectRevert(AccessControl_CallerIsNotAuthorized.selector);
        acl.setFunctionAccess(selector, role, true);
    }

    function test_RevertsWhen_RemovingAdmin() public {
        changePrank(users.admin);

        vm.expectRevert(AccessControl_CannotRemoveAdmin.selector);
        acl.setFunctionAccess(acl.setFunctionAccess.selector, DEFAULT_ADMIN_ROLE, false);

        vm.expectRevert(AccessControl_CannotRemoveAdmin.selector);
        acl.setFunctionAccess(acl.setFunctionAccess.selector, DEFAULT_ADMIN_ROLE, false);
    }

    function testFuzz_SetsFunctionAccess(uint8 role, bytes4 selector) public {
        changePrank(users.admin);

        acl.setUserRole(users.stranger, role, true);
        acl.setFunctionAccess(selector, role, true);

        assertTrue(acl.roleHasAccess(role, selector));
        assertTrue(acl.functionRoles(selector) & bytes32(uint256(1) << role) != 0);
        assertTrue(acl.canCall(users.stranger, selector));
    }

    function testFuzz_EmitsEvent(uint8 role, bytes4 selector) public {
        changePrank(users.admin);

        vm.expectEmit(diamond);
        emit FunctionAccessChanged(selector, role, true);

        acl.setFunctionAccess(selector, role, true);
    }
}
