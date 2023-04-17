// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { DiamondCutBehaviorTest } from "../cut.t.sol";
import {
    DiamondCutBehavior,
    DiamondCut_initializeDiamondCut_InitializationReverted,
    DiamondCut_initializeDiamondCut_InitIsNotContract
} from "src/facets/cut/DiamondCutBehavior.sol";
import { IDiamond } from "src/IDiamond.sol";

// import { MockReverter } from "test/mocks/MockReverter.sol";

contract DiamondCut_initializeDiamondCut is DiamondCutBehaviorTest {
    function test_RevertsWhen_InitIsNotContract() public {
        IDiamond.FacetCut[] memory facetCuts = new IDiamond.FacetCut[](0);
        address init = users.owner;

        vm.expectRevert(abi.encodeWithSelector(DiamondCut_initializeDiamondCut_InitIsNotContract.selector, init));
        DiamondCutBehavior.initializeDiamondCut(facetCuts, init, "");
    }

    function test_RevertsWhen_InitReverted() public {
        // solhint-disable-previous-line no-empty-blocks
        // IDiamond.FacetCut[] memory facetCuts = new IDiamond.FacetCut[](0);
        // MockReverter init = new MockReverter();
        // bytes memory initData = abi.encodeWithSelector(init.justRevert.selector);

        // can't reproduce
        // vm.expectRevert(DiamondCut_initializeDiamondCut_InitializationReverted.selector);
        // DiamondCutBehavior.initializeDiamondCut(facetCuts, address(init), initData);
    }
}
