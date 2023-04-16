// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { DiamondCutBehaviorTest } from "../cut.t.sol";
import {
    DiamondCutBehavior,
    DiamondCut_replaceFacet_SelectorIsZero,
    DiamondCut_replaceFacet_FunctionFromSameFacet,
    DiamondCut_replaceFacet_InexistingFunction,
    DiamondCut_replaceFacet_ImmutableFunction
} from "src/facets/cut/DiamondCutBehavior.sol";
import { DiamondIncrementalBehavior } from "src/facets/incremental/DiamondIncrementalBehavior.sol";
import { MockFacet } from "test/mocks/MockFacet.sol";

contract DiamondCut_replaceFacet is DiamondCutBehaviorTest {
    address public oldFacet;
    address public newFacet;
    bytes4[] public selectors;

    function setUp() public override {
        super.setUp();

        oldFacet = mockFacetHelper.facet();
        selectors = mockFacetHelper.selectors();

        newFacet = address(new MockFacet());

        DiamondCutBehavior.addFacet(oldFacet, selectors);
    }

    function test_RevertsWhen_SelectorIsZero() public {
        bytes4[] memory selectorsToReplace = new bytes4[](1);
        selectorsToReplace[0] = bytes4(0);

        vm.expectRevert(abi.encodeWithSelector(DiamondCut_replaceFacet_SelectorIsZero.selector));
        DiamondCutBehavior.replaceFacet(newFacet, selectorsToReplace);
    }

    function test_RevertsWhen_FunctionFromSameFacet() public {
        vm.expectRevert(abi.encodeWithSelector(DiamondCut_replaceFacet_FunctionFromSameFacet.selector, selectors[0]));
        DiamondCutBehavior.replaceFacet(oldFacet, selectors);
    }

    function test_RevertsWhen_FunctionDoesNotExist() public {
        bytes4[] memory invalidSelectors = new bytes4[](1);
        invalidSelectors[0] = 0x12345678;

        vm.expectRevert(
            abi.encodeWithSelector(DiamondCut_replaceFacet_InexistingFunction.selector, invalidSelectors[0])
        );
        DiamondCutBehavior.replaceFacet(newFacet, invalidSelectors);
    }

    function test_RevertsWhen_FunctionIsImmutable() public {
        DiamondIncrementalBehavior.turnImmutable(selectors[0]);

        vm.expectRevert(abi.encodeWithSelector(DiamondCut_replaceFacet_ImmutableFunction.selector, selectors[0]));
        DiamondCutBehavior.replaceFacet(newFacet, selectors);
    }
}
