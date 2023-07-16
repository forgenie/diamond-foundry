// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Ownable2StepFacetTest } from "../ownable2step.t.sol";

contract Ownable2Step_acceptOwnership is Ownable2StepFacetTest {
    function setUp() public override {
        super.setUp();

        ownable2Step.transferOwnership(pendingOwner);
        changePrank(pendingOwner);
    }

    function test_RevertsWhen_CallerIsNotPendingOwner() public {
        changePrank(users.stranger);

        // solhint-disable-next-line max-line-length
        vm.expectRevert(abi.encodeWithSelector(Ownable2Step_NotPendingOwner.selector, users.stranger));

        ownable2Step.acceptOwnership();
    }

    function test_EmitsEvent() public {
        vm.expectEmit();
        emit OwnershipTransferred(users.owner, pendingOwner);

        ownable2Step.acceptOwnership();
    }

    function test_SetsOwner() public {
        ownable2Step.acceptOwnership();

        assertEq(ownable2Step.owner(), pendingOwner);
    }

    function test_SetsPendingOwnerToZero() public {
        ownable2Step.acceptOwnership();

        assertEq(ownable2Step.pendingOwner(), address(0));
    }
}
