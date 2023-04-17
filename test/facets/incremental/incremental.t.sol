// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { BaseTest } from "test/Base.t.sol";
import { MockFacetHelper } from "test/mocks/MockFacet.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";
import { IDiamondCut } from "src/facets/cut/IDiamondCut.sol";

abstract contract DiamondIncrementalBehaviorTest is BaseTest {
    event SelectorTurnedImmutable(bytes4 indexed selector);

    MockFacetHelper public mockFacet;

    function setUp() public virtual override {
        super.setUp();

        IntrospectionBehavior.addInterface(type(IDiamondCut).interfaceId);
        mockFacet = new MockFacetHelper();
    }
}
