// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { AccessControlFacetTest } from "../access-control.t.sol";

contract AccessControl_setUserRole is AccessControlFacetTest {
    function test_RevertsWhen_CallerIsUnauthorized(uint8 role) public {
        changePrank(users.stranger);
        vm.expectRevert(AccessControl_CallerIsNotAuthorized.selector);
        acl.setUserRole(users.stranger, role, true);
    }

    function testFuzz_SetsUserRoles(uint8 role) public {
        changePrank(users.admin);

        acl.setUserRole(users.stranger, role, true);

        assertTrue(acl.hasRole(users.stranger, role));
        assertTrue(acl.userRoles(users.stranger) & bytes32(uint256(1) << role) != 0);
    }

    function testFuzz_EmitsEvent(uint8 role) public {
        changePrank(users.admin);

        vm.expectEmit(diamond);
        emit UserRoleUpdated(users.stranger, role, true);

        acl.setUserRole(users.stranger, role, true);
    }
}
