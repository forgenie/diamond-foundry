// SDPX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IDiamond } from "src/IDiamond.sol";
import { IDiamondCut } from "src/facets/base/cut/IDiamondCut.sol";
import { DiamondBaseFacetTest } from "../DiamondBase.t.sol";

import { MockFacet, MockFacetHelper } from "test/mocks/MockFacet.sol";
import { Ownable_checkOwner_NotOwner } from "src/facets/base/ownable/OwnableBehavior.sol";

// TODO import events from separate IEvents interface.
contract DiamondCutBehaviorTest is DiamondBaseFacetTest {
    IDiamondCut public diamondCut;
    MockFacetHelper public mockFacetHelper;

    event DiamondCut(IDiamond.FacetCut[] facetCuts, address init, bytes initData);

    function setUp() public override {
        mockFacetHelper = new MockFacetHelper();
        facets.push(mockFacetHelper);

        super.setUp();

        vm.startPrank(users.owner);

        diamondCut = IDiamondCut(diamond);
    }

    function test_RevertsWhen_CallerIsNotOwner() public {
        changePrank(users.stranger);

        IDiamond.FacetCut[] memory facetCuts = new IDiamond.FacetCut[](1);
        facetCuts[0] = mockFacetHelper.makeFacetCut(IDiamond.FacetCutAction.Add);

        vm.expectRevert(abi.encodeWithSelector(Ownable_checkOwner_NotOwner.selector, users.stranger));
        diamondCut.diamondCut(facetCuts, address(0), new bytes(0));
    }

    function test_diamondCut_addFacet() public {
        IDiamond.FacetCut[] memory facetCuts = new IDiamond.FacetCut[](1);
        facetCuts[0] = mockFacetHelper.makeFacetCut(IDiamond.FacetCutAction.Add);

        expectEmit(address(diamond));
        emit DiamondCut(facetCuts, address(0), new bytes(0));

        diamondCut.diamondCut(facetCuts, address(0), new bytes(0));
    }

    function test_diamondCut_removeFacet() public {
        IDiamond.FacetCut[] memory facetCuts = new IDiamond.FacetCut[](1);
        facetCuts[0] = mockFacetHelper.makeFacetCut(IDiamond.FacetCutAction.Add);

        // pre-req: add facet
        diamondCut.diamondCut(facetCuts, address(0), new bytes(0));

        // remove facet
        facetCuts[0].action = IDiamond.FacetCutAction.Remove;
        expectEmit(address(diamond));
        emit DiamondCut(facetCuts, address(0), new bytes(0));

        diamondCut.diamondCut(facetCuts, address(0), new bytes(0));
    }
}
