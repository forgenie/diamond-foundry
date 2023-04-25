// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { BaseTest } from "test/Base.t.sol";
import { OwnableBehavior } from "src/facets/ownable/OwnableBehavior.sol";
import { Ownable2StepBehavior } from "src/facets/ownable2step/Ownable2StepBehavior.sol";

abstract contract Ownable2StepBehaviorTest is BaseTest {
    address public pendingOwner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);

    function setUp() public override {
        super.setUp();

        pendingOwner = makeAddr("pendingOwner");

        // init
        OwnableBehavior.transferOwnership(users.owner);
    }
}
