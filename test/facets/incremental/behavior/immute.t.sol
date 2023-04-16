// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { DiamondIncrementalBehaviorTest } from "../incremental.t.sol";
import {
    DiamondIncrementalBehavior,
    DiamondIncremental_immute_AlreadyImmutable
} from "src/facets/incremental/DiamondIncrementalBehavior.sol";

contract DiamondIncremental_immute is DiamondIncrementalBehaviorTest {
    function test_RevertsWhen_AlreadyImmutable() public {
        bytes4[] memory selectors = mockFacet.selectors();
        DiamondIncrementalBehavior.immute(selectors);

        vm.expectRevert(abi.encodeWithSelector(DiamondIncremental_immute_AlreadyImmutable.selector, selectors[0]));
        DiamondIncrementalBehavior.immute(selectors);
    }

    function test_TurnsImmutable() public {
        bytes4[] memory selectors = mockFacet.selectors();

        expectEmit();
        emit SelectorTurnedImmutable(selectors[0]);

        DiamondIncrementalBehavior.immute(selectors);

        assertTrue(DiamondIncrementalBehavior.isImmutable(selectors[0]));
    }
}
