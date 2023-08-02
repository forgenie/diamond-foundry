// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { ERC20BurnableFacetTest } from "../erc20-burnable.t.sol";
import { IERC20Mintable } from "src/facets/erc20-mintable/IERC20Mintable.sol";
import { IERC20 } from "src/facets/erc20/IERC20.sol";

contract ERC20Burnable_burn is ERC20BurnableFacetTest {
    function test_RevertsWhen_BurnAmountExceedesBalance() public {
        vm.expectRevert(ERC20_BurnExceedsBalance.selector);

        erc20Burnable.burn(1);
    }

    function test_EmitsEvent() public {
        IERC20Mintable(diamond).mint(users.owner, 100);

        vm.expectEmit(diamond);
        emit Transfer(users.owner, address(0), 100);

        erc20Burnable.burn(100);
    }

    function test_BurnsTokens() public {
        IERC20Mintable(diamond).mint(users.owner, 100);

        erc20Burnable.burn(100);

        assertEq(IERC20(diamond).balanceOf(users.owner), 0);
        assertEq(IERC20(diamond).totalSupply(), 0);
    }
}
