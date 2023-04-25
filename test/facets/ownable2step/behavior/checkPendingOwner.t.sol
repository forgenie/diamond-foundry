// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {
    Ownable2StepBehavior,
    Ownable2Step_checkPendingOwner_NotPendingOwner
} from "src/facets/ownable2step/Ownable2StepBehavior.sol";
import { Ownable2StepBehaviorTest } from "../ownable2step.t.sol";

contract Ownable2Step_checkPendingOwner is Ownable2StepBehaviorTest {
    function test_RevertsWhen_AccountIsNotPendingOwner() public {
        address account = makeAddr("account");

        vm.expectRevert(abi.encodeWithSelector(Ownable2Step_checkPendingOwner_NotPendingOwner.selector, account));

        Ownable2StepBehavior.checkPendingOwner(account);
    }
}
