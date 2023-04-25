// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Ownable2StepBehaviorTest } from "../ownable2step.t.sol";
import { Ownable2StepBehavior } from "src/facets/ownable2step/Ownable2StepBehavior.sol";
import { OwnableBehavior } from "src/facets/ownable/OwnableBehavior.sol";

contract Ownable2StepBehavior_acceptOwnership is Ownable2StepBehaviorTest {
    function test_EmitsEvent() public {
        expectEmit();
        emit OwnershipTransferred(users.owner, pendingOwner);

        Ownable2StepBehavior.acceptOwnership(pendingOwner);
    }

    function test_SetsOwner() public {
        Ownable2StepBehavior.acceptOwnership(pendingOwner);

        assertEq(OwnableBehavior.owner(), pendingOwner);
    }

    function test_SetsPendingOwnerToZero() public {
        Ownable2StepBehavior.acceptOwnership(pendingOwner);

        assertEq(Ownable2StepBehavior.pendingOwner(), address(0));
    }
}
