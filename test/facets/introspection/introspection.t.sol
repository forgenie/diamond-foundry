// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { FacetInit } from "src/factory/IDiamondFactory.sol";
import { Diamond } from "src/Diamond.sol";
import { IERC165, IIntrospectionEvents } from "src/facets/introspection/IERC165.sol";
import { BaseTest } from "test/Base.t.sol";
import { FacetHelper } from "test/facets/Helpers.t.sol";
import { IntrospectionBase } from "src/facets/introspection/IntrospectionBase.sol";

abstract contract IntrospectionBaseTest is IIntrospectionEvents, IntrospectionBase, BaseTest {
    function setUp() public virtual override initializer {
        super.setUp();

        __Introspection_init();
    }
}
