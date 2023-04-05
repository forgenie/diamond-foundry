// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IDiamond, Diamond } from "src/Diamond.sol";
import { BaseTest } from "../Base.t.sol";
import { FacetHelper } from "./FacetHelper.t.sol";

abstract contract FacetTest is BaseTest {
    address public diamond;
    FacetHelper[] public facets;

    function setUp() public virtual override {
        super.setUp();

        IDiamond.FacetCut[] memory cuts = new IDiamond.FacetCut[](facets.length);

        for (uint256 i = 0; i < facets.length; i++) {
            cuts[i] = facets[i].makeFacetCut(IDiamond.FacetCutAction.Add);
        }

        diamond = address(
            new Diamond(Diamond.InitParams({
                // currently accept only one base facet
                baseFacets: cuts, init: facets[0].facet(),
                initData: abi.encodeWithSelector(
                        facets[0].initializer(),
                        users.owner
                )
            }))
        );
    }
}
