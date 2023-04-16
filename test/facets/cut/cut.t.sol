// SDPX-License-Identifier: MIT
pragma solidity 0.8.19;

import { MockFacet, MockFacetHelper } from "test/mocks/MockFacet.sol";
import { BaseTest } from "test/Base.t.sol";
import { IDiamond, IDiamondCut } from "src/facets/cut/IDiamondCut.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";

abstract contract DiamondCutBehaviorTest is BaseTest {
    MockFacetHelper public mockFacetHelper;

    event DiamondCut(IDiamond.FacetCut[] facetCuts, address init, bytes initData);

    function setUp() public virtual override {
        super.setUp();

        mockFacetHelper = new MockFacetHelper();
        IntrospectionBehavior.addInterface(type(IDiamondCut).interfaceId);
    }
}
