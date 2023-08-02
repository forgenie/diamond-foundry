// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { ERC20FacetTest } from "../erc20.t.sol";

contract ERC20_init is ERC20FacetTest {
    function test_InitializesCorrectly() public {
        assertEq(erc20.name(), name);
        assertEq(erc20.symbol(), symbol);
        assertEq(erc20.decimals(), decimals);
    }
}
