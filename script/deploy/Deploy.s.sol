// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { IERC721A } from "@erc721a/IERC721A.sol";
import { BaseScript, FacetHelper } from "../Base.s.sol";
import { IDiamond, Diamond } from "src/diamond/Diamond.sol";
import { DiamondFoundry } from "src/DiamondFoundry.sol";

contract Deploy is BaseScript {
    function run() public broadcaster {
        DiamondFoundry foundry = new DiamondFoundry();

        for (uint256 i = 0; i < facetHelpers.length; i++) {
            FacetHelper helper = facetHelpers[i];
            foundry.deployFacet(salt, helper.creationCode(), helper.selectors());
        }
    }
}
