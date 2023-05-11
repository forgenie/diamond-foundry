// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { BaseTest } from "test/Base.t.sol";
import { IIntrospectionEvents } from "src/facets/introspection/IERC165.sol";
import { IntrospectionBase } from "src/facets/introspection/IntrospectionBase.sol";

abstract contract IntrospectionBaseTest is IIntrospectionEvents, IntrospectionBase, BaseTest {
    function setUp() public virtual override initializer {
        super.setUp();

        __Introspection_init();
    }
}
