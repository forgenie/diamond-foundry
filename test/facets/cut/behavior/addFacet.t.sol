// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { DiamondCutBehaviorTest } from "../cut.t.sol";
import {
    DiamondCutBehavior,
    DiamondCut_addFacet_SelectorIsZero,
    DiamondCut_addFacet_FunctionAlreadyExists
} from "src/facets/cut/DiamondCutBehavior.sol";

contract DiamondCut_addFacet is DiamondCutBehaviorTest {
    function test_RevertsWhen_FunctionAlreadyExists() public {
        address facet = address(mockFacetHelper.facet());
        bytes4[] memory selectors = mockFacetHelper.selectors();

        DiamondCutBehavior.addFacet(facet, selectors);

        vm.expectRevert(abi.encodeWithSelector(DiamondCut_addFacet_FunctionAlreadyExists.selector, selectors[0]));
        DiamondCutBehavior.addFacet(facet, selectors);
    }

    function test_RevertsWhen_SelectorIsZero() public {
        address facet = address(mockFacetHelper.facet());
        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = bytes4(0);

        vm.expectRevert(abi.encodeWithSelector(DiamondCut_addFacet_SelectorIsZero.selector));
        DiamondCutBehavior.addFacet(facet, selectors);
    }
}
