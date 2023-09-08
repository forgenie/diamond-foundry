// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { BaseScript, FacetHelper } from "../Base.s.sol";
import { FacetRegistry } from "src/registry/FacetRegistry.sol";

contract Deploy is BaseScript {
    function run() public broadcaster {
        FacetRegistry registry = new FacetRegistry();

        for (uint256 i = 0; i < facetHelpers.length; i++) {
            FacetHelper helper = facetHelpers[i];
            registry.deployFacet(salt, helper.creationCode(), helper.selectors());
        }
    }
}
