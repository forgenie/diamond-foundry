// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { OwnableBehaviorTest } from "../ownable.t.sol";
import { OwnableBehavior, Ownable_checkOwner_NotOwner } from "src/facets/ownable/OwnableBehavior.sol";

contract Ownable_checkOwner is OwnableBehaviorTest {
    function test_RevertsWhen_AccountIsNotOwner() public {
        vm.expectRevert(abi.encodeWithSelector(Ownable_checkOwner_NotOwner.selector, users.stranger));
        OwnableBehavior.checkOwner(users.stranger);
    }
}
