// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Diamond } from "src/Diamond.sol";
import { BaseTest } from "../Base.t.sol";
import { DiamondContext } from "./Diamond.t.sol";

abstract contract BaseFacetTest is BaseTest, DiamondContext {
    function setUp() public virtual override(BaseTest, DiamondContext) {
        BaseTest.setUp();

        diamond = address(new Diamond(diamondInitParams()));

        DiamondContext.setUp();
    }

    function diamondInitParams() internal virtual returns (Diamond.InitParams memory);
}
