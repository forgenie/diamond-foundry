// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { AccessControlFacetTest } from "../access-control.t.sol";
import { AccessControl_CannotRemoveAdmin } from "src/facets/access-control/AccessControlFacet.sol";

contract AccessControl_setUserRole is AccessControlFacetTest {
    function test_RevertsWhen_CallerIsUnauthorized() public {
        changePrank(users.stranger);

        // call
    }

    function test_UserCanCall() public {
        // todo
    }
}
