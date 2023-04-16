// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { OwnableBehavior } from "src/facets/ownable/OwnableBehavior.sol";

import { BaseTest } from "test/Base.t.sol";

contract OwnableBehaviorTest is BaseTest {
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function setUp() public override {
        super.setUp();

        // init
        OwnableBehavior.transferOwnership(users.owner);
    }
}
