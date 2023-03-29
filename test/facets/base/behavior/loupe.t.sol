// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IDiamondLoupe } from "src/facets/base/loupe/IDiamondLoupe.sol";

import { DiamondBaseFacetTest } from "test/facets/base/DiamondBase.t.sol";

import { console } from "forge-std/console.sol";

contract DiamondLoupeTest is DiamondBaseFacetTest {
    IDiamondLoupe public diamondLoupe;

    function setUp() public override {
        super.setUp();

        diamondLoupe = IDiamondLoupe(diamondBase);
    }

    function test_facetAddresses() public {
        address[] memory facetAddresses = diamondLoupe.facetAddresses();

        console.log("facetAddresses: %s", facetAddresses.length);
    }
}
