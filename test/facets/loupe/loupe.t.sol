// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { MockFacetHelper } from "test/mocks/MockFacet.sol";
import { BaseTest } from "test/Base.t.sol";

contract DiamondLoupeBehaviorTest is BaseTest {
    MockFacetHelper mockFacet;

    function setUp() public override {
        super.setUp();

        mockFacet = new MockFacetHelper();
    }
}
