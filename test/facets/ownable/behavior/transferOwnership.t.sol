// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { OwnableBehaviorTest } from "../ownable.t.sol";

import { OwnableBehavior, Ownable_transferOwnership_ZeroAddress } from "src/facets/ownable/OwnableBehavior.sol";

contract Ownable_transferOwnership is OwnableBehaviorTest {
    function test_RevertsWhen_NewOwnerIsZeroAddress() public {
        vm.expectRevert(Ownable_transferOwnership_ZeroAddress.selector);

        OwnableBehavior.transferOwnership(address(0));
    }

    function test_EmitsEvent() public {
        expectEmit();
        emit OwnershipTransferred(users.owner, users.stranger);

        OwnableBehavior.transferOwnership(users.stranger);
    }

    function test_TransfersOwner() public {
        OwnableBehavior.transferOwnership(users.stranger);

        assertEq(OwnableBehavior.owner(), users.stranger);
    }
}
