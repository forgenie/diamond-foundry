// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import { ReentrancyGuard } from "src/utils/ReentrancyGuard.sol";

contract MockMalicious {
    constructor(MockReentrancy target) {
        target.increment();
    }
}

contract MockReentrancy is ReentrancyGuard {
    uint256 public counter;

    function increment() public nonReentrant {
        counter++;

        new MockMalicious(this);
    }
}
