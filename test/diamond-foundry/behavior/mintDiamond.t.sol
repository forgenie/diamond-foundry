// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { DiamondFoundryTest } from "../DiamondFoundry.t.sol";
import { IDiamond, Diamond } from "src/diamond/Diamond.sol";
import { OwnableFacetHelper } from "test/facets/ownable/ownable.t.sol";
import { DiamondLoupeFacetHelper } from "test/facets/loupe/loupe.t.sol";
import { MULTI_INIT_ADDRESS } from "src/Constants.sol";

contract DiamondFoundry_mintDiamond is DiamondFoundryTest {
    Diamond.InitParams public diamondInitParams;

    function setUp() public override {
        super.setUp();

        OwnableFacetHelper ownableHelper = new OwnableFacetHelper();
        DiamondLoupeFacetHelper loupeHelper = new DiamondLoupeFacetHelper();

        IDiamond.FacetCut[] memory baseFacets = new IDiamond.FacetCut[](2);
        baseFacets[0] = ownableHelper.makeFacetCut(IDiamond.FacetCutAction.Add);
        baseFacets[1] = loupeHelper.makeFacetCut(IDiamond.FacetCutAction.Add);

        IDiamond.MultiInit[] memory diamondInitData = new IDiamond.MultiInit[](2);
        diamondInitData[0] = ownableHelper.makeInitData(abi.encode(users.owner));
        diamondInitData[1] = loupeHelper.makeInitData("");

        diamondInitParams.baseFacets.push(baseFacets[0]);
        diamondInitParams.baseFacets.push(baseFacets[1]);
        diamondInitParams.init = MULTI_INIT_ADDRESS;
        diamondInitParams.initData = abi.encode(diamondInitData);
    }

    function test_MintDiamond() public {
        uint256 startTokenId = 1;
        address diamond = diamondFoundry.mintDiamond(diamondInitParams);

        assertEq(diamondFoundry.ownerOf(startTokenId), users.owner);
        assertEq(diamondFoundry.diamondAddress(startTokenId), diamond);
        assertEq(diamondFoundry.diamondId(diamond), startTokenId);
    }
}
