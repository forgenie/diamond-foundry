// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Diamond, FacetHelper } from "test/facets/Facet.t.sol";
import { DiamondFactoryTest } from "../factory.t.sol";
import { DiamondCutFacetHelper } from "test/facets/cut/cut.t.sol";
import { DiamondLoupeFacetHelper } from "test/facets/loupe/loupe.t.sol";

contract DiamondFactory_createDiamond is DiamondFactoryTest {
    Diamond.InitParams public initParams;

    function test_RevertsWhen_DiamondDoesNotHaveLoupe() public {
        FacetHelper diamondCutHelper = new DiamondCutFacetHelper();
        FacetHelper diamondLoupeHelper = new DiamondLoupeFacetHelper();

        FacetCut[] memory baseFacets = new FacetCut[](2);
        baseFacets[0] = diamondCutHelper.makeFacetCut(FacetCutAction.Add);
        baseFacets[1] = diamondLoupeHelper.makeFacetCut(FacetCutAction.Add);

        // don't initialize loupe
        initParams.baseFacets.push(baseFacets[0]);
        initParams.baseFacets.push(baseFacets[1]);
        initParams.init = address(0);
        initParams.initData = "";

        vm.expectRevert(DiamondFactory_LoupeNotSupported.selector);
        diamondFactory.createDiamond(initParams);
    }
}
