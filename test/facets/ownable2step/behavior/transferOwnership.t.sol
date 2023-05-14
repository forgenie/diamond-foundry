// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Ownable2StepFacetTest } from "../ownable2step.t.sol";
import { Ownable_checkOwner_NotOwner } from "src/facets/ownable/OwnableBehavior.sol";

contract Ownable2Step_transferOwnership is Ownable2StepFacetTest {
    function test_RevertsWhen_CallerIsNotOwner() public {
        changePrank(users.stranger);

        vm.expectRevert(abi.encodeWithSelector(Ownable_checkOwner_NotOwner.selector, users.stranger));

        ownable2Step.transferOwnership(pendingOwner);
    }

    function test_EmitsEvent() public {
        vm.expectEmit();
        emit OwnershipTransferStarted(users.owner, pendingOwner);

        ownable2Step.transferOwnership(pendingOwner);
    }

    function test_SetsPendingOwner() public {
        ownable2Step.transferOwnership(pendingOwner);

        assertEq(ownable2Step.pendingOwner(), pendingOwner);
    }
}
