// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IDiamond } from "src/IDiamond.sol";

import { DiamondBaseFacet } from "src/facets/base/DiamondBaseFacet.sol";
import { BaseTest } from "test/Base.t.sol";

abstract contract DiamondBaseFacetTest is BaseTest {
    DiamondBaseFacet public diamondBase;

    address[] internal _facets;
    IDiamond.FacetCut[] internal _facetCuts;
    bytes4[] internal _selectors;

    function setUp() public virtual override {
        super.setUp();

        diamondBase = new DiamondBaseFacet();
        diamondBase.initialize(users.owner);
    }
}
