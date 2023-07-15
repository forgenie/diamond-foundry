// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { AccessControlFacetTest } from "../access-control.t.sol";
// error AccessControl_CannotRemoveAdmin();

contract AccessControl_setUserRole is AccessControlFacetTest {
    function test_RevertsWhen_CallerIsUnauthorized() public { }
}
