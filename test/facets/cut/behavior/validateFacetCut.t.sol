// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamond } from "src/IDiamond.sol";
import { DiamondCutBehaviorTest } from "../cut.t.sol";
import {
    DiamondCutBehavior,
    DiamondCut_validateFacetCut_IncorrectFacetCutAction,
    DiamondCut_validateFacetCut_FacetIsNotContract,
    DiamondCut_validateFacetCut_FacetIsZeroAddress,
    DiamondCut_validateFacetCut_SelectorArrayEmpty
} from "src/facets/cut/DiamondCutBehavior.sol";

contract DiamondCut_validateFacetCut is DiamondCutBehaviorTest {
    function test_RevertsWhen_IncorrectFacetCutAction() public {
        // solhint-disable-previous-line no-empty-blocks
        // can't reproduce this

        // vm.expectRevert(DiamondCut_validateFacetCut_IncorrectFacetCutAction.selector);
        // DiamondCutBehavior.validateFacetCut(IDiamond.FacetCut(address(this), 3, new bytes4[](0)));
    }

    function test_RevertsWhen_FacetIsZeroAddress() public {
        vm.expectRevert(DiamondCut_validateFacetCut_FacetIsZeroAddress.selector);
        DiamondCutBehavior.validateFacetCut(
            IDiamond.FacetCut({ action: IDiamond.FacetCutAction.Add, facet: address(0), selectors: new bytes4[](0) })
        );
    }

    function test_RevertsWhen_FacetIsNotContract() public {
        address facet = users.owner;
        vm.expectRevert(abi.encodeWithSelector(DiamondCut_validateFacetCut_FacetIsNotContract.selector, facet));
        DiamondCutBehavior.validateFacetCut(
            IDiamond.FacetCut({ action: IDiamond.FacetCutAction.Add, facet: facet, selectors: new bytes4[](0) })
        );
    }

    function test_RevertsWhen_SelectorArrayEmpty() public {
        address facet = address(mockFacetHelper.facet());
        vm.expectRevert(abi.encodeWithSelector(DiamondCut_validateFacetCut_SelectorArrayEmpty.selector, facet));
        DiamondCutBehavior.validateFacetCut(
            IDiamond.FacetCut({ action: IDiamond.FacetCutAction.Add, facet: facet, selectors: new bytes4[](0) })
        );
    }
}
