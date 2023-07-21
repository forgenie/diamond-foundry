// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { BaseTest } from "test/Base.t.sol";
import { MockReentrancy } from "test/mocks/MockReentrancy.sol";
import { ReentrancyGuard } from "src/utils/ReentrancyGuard.sol";

contract ReentrancyGuardTest is BaseTest {
    MockReentrancy public target;

    function setUp() public override {
        super.setUp();
        target = new MockReentrancy();
    }

    function test_RevertsWhen_DetectsReentrancy() public {
        vm.expectRevert(ReentrancyGuard.ReentrantCall.selector);

        target.increment();
    }
}
