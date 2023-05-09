// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IDiamond, Diamond } from "src/Diamond.sol";
import { BaseTest } from "../Base.t.sol";
import { DiamondContext } from "./Diamond.t.sol";

abstract contract FacetTest is BaseTest, IDiamond {
    /// @dev Attach facet interface to diamond for testing
    address public diamond;

    function setUp() public virtual override {
        super.setUp();

        diamond = address(new Diamond(diamondInitParams()));
    }

    /// @dev Add facet as init param for diamond
    function diamondInitParams() internal virtual returns (Diamond.InitParams memory);
}
