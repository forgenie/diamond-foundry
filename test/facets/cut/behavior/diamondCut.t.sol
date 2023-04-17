// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { DiamondCutBehaviorTest } from "../cut.t.sol";
import { DiamondCutBehavior } from "src/facets/cut/DiamondCutBehavior.sol";
import { IDiamond } from "src/IDiamond.sol";
import { MockFacetHelper } from "test/mocks/MockFacet.sol";

contract DiamondCut_diamondCut is DiamondCutBehaviorTest {
    MockFacetHelper public newFacetHelper;
    address public init = address(0);
    bytes public initData = "";

    function setUp() public override {
        super.setUp();

        newFacetHelper = new MockFacetHelper();
    }

    function test_EmitsEvent_OnAllActions() public {
        IDiamond.FacetCut[] memory facetCuts = new IDiamond.FacetCut[](1);
        facetCuts[0] = mockFacetHelper.makeFacetCut(IDiamond.FacetCutAction.Add);

        expectEmit();
        emit DiamondCut(facetCuts, init, initData);
        DiamondCutBehavior.diamondCut(facetCuts, init, initData);

        facetCuts[0] = newFacetHelper.makeFacetCut(IDiamond.FacetCutAction.Replace);
        expectEmit();
        emit DiamondCut(facetCuts, init, initData);
        DiamondCutBehavior.diamondCut(facetCuts, init, initData);

        facetCuts[0] = newFacetHelper.makeFacetCut(IDiamond.FacetCutAction.Remove);
        expectEmit();
        emit DiamondCut(facetCuts, init, initData);
        DiamondCutBehavior.diamondCut(facetCuts, init, initData);
    }
}
