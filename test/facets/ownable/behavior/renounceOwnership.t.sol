// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { OwnableBehaviorTest } from "../ownable.t.sol";
import { OwnableBehavior } from "src/facets/ownable/OwnableBehavior.sol";

contract Ownable_renounceOwnership is OwnableBehaviorTest {
    function test_EmitsEvent() public {
        expectEmit();
        emit OwnershipTransferred(users.owner, address(0));

        OwnableBehavior.renounceOwnership();
    }

    function test_RenouncesOwner() public {
        OwnableBehavior.renounceOwnership();

        assertEq(OwnableBehavior.owner(), address(0));
    }
}
