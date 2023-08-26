// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { BaseTest } from "../Base.t.sol";
import { DiamondFoundry } from "src/DiamondFoundry.sol";
import { Diamond } from "src/diamond/Diamond.sol";

abstract contract DiamondFoundryTest is BaseTest {
    DiamondFoundry public diamondFoundry;

    function setUp() public virtual override {
        super.setUp();

        diamondFoundry = new DiamondFoundry( );
    }
}
