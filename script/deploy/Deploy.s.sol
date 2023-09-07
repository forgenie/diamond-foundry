// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { BaseScript, FacetHelper } from "../Base.s.sol";
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
