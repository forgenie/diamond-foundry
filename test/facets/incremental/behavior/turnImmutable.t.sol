// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { DiamondIncrementalBehaviorTest } from "../incremental.t.sol";
import {
    DiamondIncrementalBehavior,
    DiamondIncremental_turnImmutable_AlreadyImmutable
} from "src/facets/incremental/DiamondIncrementalBehavior.sol";

contract DiamondIncremental_turnImmutable is DiamondIncrementalBehaviorTest {
    function test_RevertsWhen_AlreadyImmutable() public {
        bytes4 selector = mockFacet.selectors()[0];
        DiamondIncrementalBehavior.turnImmutable(selector);

        vm.expectRevert(abi.encodeWithSelector(DiamondIncremental_turnImmutable_AlreadyImmutable.selector, selector));
        DiamondIncrementalBehavior.turnImmutable(selector);
    }

    function test_TurnsImmutable() public {
        bytes4 selector = mockFacet.selectors()[0];

        expectEmit();
        emit SelectorTurnedImmutable(selector);

        DiamondIncrementalBehavior.turnImmutable(selector);

        assertTrue(DiamondIncrementalBehavior.isImmutable(selector));
    }
}
