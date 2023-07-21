// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { IDiamond } from "src/diamond/Diamond.sol";
import { DiamondCutFacetTest } from "../cut.t.sol";

contract DiamondCut_diamondCut is DiamondCutFacetTest {
    function test_RevertsWhen_InitIsNotContract() public {
        address init = users.owner;

        vm.expectRevert(abi.encodeWithSelector(DiamondCut_InitIsNotContract.selector, init));
        diamondCut.diamondCut(facetCuts, init, "");
    }

    function test_RevertsWhen_FacetIsZeroAddress() public {
        facetCuts.push(FacetCut({ action: FacetCutAction.Add, facet: address(0), selectors: new bytes4[](0) }));

        vm.expectRevert(DiamondCut_FacetIsZeroAddress.selector);
        diamondCut.diamondCut(facetCuts, address(0), "");
    }

    function test_RevertsWhen_FacetIsNotContract() public {
        address facet = users.owner;
        facetCuts.push(FacetCut({ action: FacetCutAction.Add, facet: facet, selectors: new bytes4[](0) }));

        vm.expectRevert(abi.encodeWithSelector(DiamondCut_FacetIsNotContract.selector, facet));

        diamondCut.diamondCut(facetCuts, address(0), "");
    }

    function test_RevertsWhen_SelectorArrayEmpty() public {
        address facet = address(mockFacetHelper.facet());
        facetCuts.push(FacetCut({ action: FacetCutAction.Add, facet: facet, selectors: new bytes4[](0) }));

        vm.expectRevert(abi.encodeWithSelector(DiamondCut_SelectorArrayEmpty.selector, facet));

        diamondCut.diamondCut(facetCuts, address(0), "");
    }

    function test_EmitsEvent() public {
        facetCuts.push(
            FacetCut({
                action: FacetCutAction.Add,
                facet: address(mockFacetHelper.facet()),
                selectors: mockFacetHelper.selectors()
            })
        );

        vm.expectEmit(diamond);
        emit DiamondCut(facetCuts, address(0), "");

        diamondCut.diamondCut(facetCuts, address(0), "");
    }

    /**
     * ------------------------ addFacet ------------------------
     */

    function test_OnAdd_RevertsWhen_FunctionAlreadyExists() public {
        facetCuts.push(mockFacetHelper.makeFacetCut(FacetCutAction.Add));
        diamondCut.diamondCut(facetCuts, address(0), "");

        bytes4[] memory selectors = mockFacetHelper.selectors();
        vm.expectRevert(abi.encodeWithSelector(DiamondCut_FunctionAlreadyExists.selector, selectors[0]));

        diamondCut.diamondCut(facetCuts, address(0), "");
    }

    function test_OnAdd_RevertsWhen_SelectorIsZero() public {
        address facet = address(mockFacetHelper.facet());
        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = bytes4(0);
        facetCuts.push(FacetCut({ action: FacetCutAction.Add, facet: facet, selectors: selectors }));

        vm.expectRevert(DiamondCut_SelectorIsZero.selector);

        diamondCut.diamondCut(facetCuts, address(0), "");
    }

    /**
     * ------------------------ removeFacet ------------------------
     */

    function test_OnRemove_RevertsWhen_RemovingFromOtherFacet() public {
        address facet = address(mockFacetHelper.facet());
        bytes4[] memory selectorsToRemove = new bytes4[](1);
        selectorsToRemove[0] = 0x12345678;

        facetCuts.push(FacetCut({ action: FacetCutAction.Remove, facet: facet, selectors: selectorsToRemove }));

        vm.expectRevert(
            abi.encodeWithSelector(DiamondCut_CannotRemoveFromOtherFacet.selector, facet, selectorsToRemove[0])
        );

        diamondCut.diamondCut(facetCuts, address(0), "");
    }

    function test_OnRemove_RevertsWhen_SelectorIsZero() public {
        bytes4[] memory selectorsToRemove = new bytes4[](1);
        selectorsToRemove[0] = bytes4(0);
        facetCuts.push(
            FacetCut({
                action: FacetCutAction.Remove,
                facet: address(mockFacetHelper.facet()),
                selectors: selectorsToRemove
            })
        );

        vm.expectRevert(DiamondCut_SelectorIsZero.selector);

        diamondCut.diamondCut(facetCuts, address(0), "");
    }

    function test_OnRemove_RevertsWhen_SelectorIsImmutable() public {
        bytes4[] memory selectors = mockFacetHelper.selectors();
        facetCuts.push(FacetCut({ action: FacetCutAction.Remove, facet: diamond, selectors: selectors }));

        vm.expectRevert(DiamondCut_ImmutableFacet.selector);

        diamondCut.diamondCut(facetCuts, address(0), "");
    }

    /**
     * ------------------------ replaceFacet ------------------------
     */

    function test_OnReplace_RevertsWhen_SelectorIsZero() public {
        bytes4[] memory selectorsToReplace = new bytes4[](1);
        selectorsToReplace[0] = bytes4(0);

        facetCuts.push(
            FacetCut({
                action: FacetCutAction.Replace,
                facet: address(mockFacetHelper.facet()),
                selectors: selectorsToReplace
            })
        );

        vm.expectRevert(DiamondCut_SelectorIsZero.selector);

        diamondCut.diamondCut(facetCuts, address(0), "");
    }

    function test_OnReplace_RevertsWhen_FunctionFromSameFacet() public {
        bytes4[] memory selectors = mockFacetHelper.selectors();
        facetCuts.push(mockFacetHelper.makeFacetCut(FacetCutAction.Add));
        facetCuts.push(mockFacetHelper.makeFacetCut(FacetCutAction.Replace));

        vm.expectRevert(abi.encodeWithSelector(DiamondCut_FunctionFromSameFacet.selector, selectors[0]));

        diamondCut.diamondCut(facetCuts, address(0), "");
    }

    function test_OnReplace_RevertsWhen_FunctionDoesNotExist() public {
        bytes4[] memory invalidSelectors = new bytes4[](1);
        invalidSelectors[0] = 0x12345678;

        facetCuts.push(
            FacetCut({
                action: FacetCutAction.Replace,
                facet: address(mockFacetHelper.facet()),
                selectors: invalidSelectors
            })
        );

        vm.expectRevert(abi.encodeWithSelector(DiamondCut_NonExistingFunction.selector, invalidSelectors[0]));

        diamondCut.diamondCut(facetCuts, address(0), "");
    }

    function test_OnReplace_RevertsWhen_FunctionIsImmutable() public {
        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = 0x12345678;
        facetCuts.push(FacetCut({ action: FacetCutAction.Add, facet: diamond, selectors: selectors }));
        facetCuts.push(FacetCut({ action: FacetCutAction.Replace, facet: diamond, selectors: selectors }));

        vm.expectRevert(DiamondCut_ImmutableFacet.selector);

        diamondCut.diamondCut(facetCuts, address(0), "");
    }
}
