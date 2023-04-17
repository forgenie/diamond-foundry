// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { DiamondCutBehaviorTest } from "../cut.t.sol";
import {
    DiamondCutBehavior,
    DiamondCut_removeFacet_CannotRemoveFromOtherFacet,
    DiamondCut_removeFacet_SelectorIsZero,
    DiamondCut_removeFacet_ImmutableFunction
} from "src/facets/cut/DiamondCutBehavior.sol";
import { DiamondIncrementalBehavior } from "src/facets/incremental/DiamondIncrementalBehavior.sol";

contract DiamondCut_removeFacet is DiamondCutBehaviorTest {
    address public facet;
    bytes4[] public selectors;

    function setUp() public override {
        super.setUp();

        facet = mockFacetHelper.facet();
        selectors = mockFacetHelper.selectors();

        DiamondCutBehavior.addFacet(facet, selectors);
    }

    function test_RevertsWhen_RemovingFromOtherFacet() public {
        bytes4[] memory selectorsToRemove = new bytes4[](1);
        selectorsToRemove[0] = 0x12345678;

        vm.expectRevert(
            abi.encodeWithSelector(
                DiamondCut_removeFacet_CannotRemoveFromOtherFacet.selector, facet, selectorsToRemove[0]
            )
        );
        DiamondCutBehavior.removeFacet(facet, selectorsToRemove);
    }

    function test_RevertsWhen_SelectorIsZero() public {
        bytes4[] memory selectorsToRemove = new bytes4[](1);
        selectorsToRemove[0] = bytes4(0);

        vm.expectRevert(abi.encodeWithSelector(DiamondCut_removeFacet_SelectorIsZero.selector));
        DiamondCutBehavior.removeFacet(facet, selectorsToRemove);
    }

    function test_RevertsWhen_SelectorIsImmutable() public {
        DiamondIncrementalBehavior.turnImmutable(selectors[0]);

        vm.expectRevert(abi.encodeWithSelector(DiamondCut_removeFacet_ImmutableFunction.selector, selectors[0]));
        DiamondCutBehavior.removeFacet(facet, selectors);
    }
}
