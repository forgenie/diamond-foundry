// SDPX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IDiamond } from "src/IDiamond.sol";
import { IDiamondCut } from "src/facets/base/cut/IDiamondCut.sol";
import { DiamondBaseFacetTest } from "../DiamondBase.t.sol";

import { MockFacet } from "test/mocks/MockFacet.sol";
import { Ownable_checkOwner_NotOwner } from "src/facets/base/ownable/OwnableBehavior.sol";

// TODO import events from separate IEvents interface.
contract DiamondCutBehaviorTest is DiamondBaseFacetTest {
    IDiamondCut public diamondCut;

    event DiamondCut(IDiamond.FacetCut[] facetCuts, address init, bytes initData);

    function setUp() public override {
        super.setUp();

        vm.startPrank(users.owner);

        diamondCut = IDiamondCut(diamondBase);

        // cache selectors and facetCuts
        _selectors.push(MockFacet.mockFunction.selector);
        _facetCuts.push(
            IDiamond.FacetCut({ facet: address(mockFacet), action: IDiamond.FacetCutAction.Add, selectors: _selectors })
        );
    }

    function test_RevertsWhen_CallerIsNotOwner() public {
        changePrank(users.stranger);

        vm.expectRevert(abi.encodeWithSelector(Ownable_checkOwner_NotOwner.selector, users.stranger));

        diamondCut.diamondCut(_facetCuts, address(0), new bytes(0));
    }

    function test_diamondCut_addFacet() public {
        expectEmit(address(diamondBase));
        emit DiamondCut(_facetCuts, address(0), new bytes(0));

        diamondCut.diamondCut(_facetCuts, address(0), new bytes(0));
    }
}
