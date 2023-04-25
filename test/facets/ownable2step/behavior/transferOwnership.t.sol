// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Ownable2StepBehaviorTest } from "../ownable2step.t.sol";
import { Ownable2StepBehavior } from "src/facets/ownable2step/Ownable2StepBehavior.sol";

contract Ownable2Step_transferOwnership is Ownable2StepBehaviorTest {
    function test_EmitsEvent() public {
        expectEmit();
        emit OwnershipTransferStarted(users.owner, pendingOwner);

        Ownable2StepBehavior.transferOwnership(users.owner, pendingOwner);
    }

    function test_SetsPendingOwner() public {
        Ownable2StepBehavior.transferOwnership(users.owner, pendingOwner);

        assertEq(Ownable2StepBehavior.pendingOwner(), pendingOwner);
    }
}
