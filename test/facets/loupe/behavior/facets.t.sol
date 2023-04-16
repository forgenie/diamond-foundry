// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { DiamondLoupeBehaviorTest } from "../loupe.t.sol";
import { DiamondCutBehavior } from "src/facets/cut/DiamondCutBehavior.sol";
import { DiamondLoupeBehavior } from "src/facets/loupe/DiamondLoupeBehavior.sol";
import { MockFacet } from "test/mocks/MockFacet.sol";
import { IDiamondLoupe } from "src/facets/loupe/IDiamondLoupe.sol";

contract DiamondLoupe_facets is DiamondLoupeBehaviorTest {
    function test_OnAdd_ReturnsCorrectly() public multiFacetTest(mockFacet()) {
        DiamondCutBehavior.addFacet(facet.facet(), facet.selectors());

        IDiamondLoupe.Facet[] memory loupeFacets = DiamondLoupeBehavior.facets();

        // todo
    }
}
