// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IERC165 } from "src/facets/introspection/IERC165.sol";
import { BaseTest } from "test/Base.t.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";

abstract contract IntrospectionBehaviorTest is BaseTest {
    function setUp() public virtual override {
        super.setUp();

        IntrospectionBehavior.addInterface(type(IERC165).interfaceId);
    }
}
