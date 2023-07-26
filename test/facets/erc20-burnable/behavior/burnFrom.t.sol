// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { ERC20BurnableFacetTest } from "../erc20-burnable.t.sol";
import { IERC20Mintable } from "src/facets/erc20-mintable/IERC20Mintable.sol";
import { IERC20 } from "src/facets/erc20/IERC20.sol";
import { Facet } from "src/facets/Facet.sol";

contract ERC20Burnable_burnFrom is ERC20BurnableFacetTest {
    function test_RevertsWhen_CallerIsUnauthorized() public {
        changePrank(users.stranger);

        vm.expectRevert(Facet.CallerIsNotAuthorized.selector);

        erc20Burnable.burnFrom(users.owner, 1);
    }

    function test_RevertsWhen_FromIsAddressZero() public {
        vm.expectRevert(ERC20_BurnFromZeroAddress.selector);

        erc20Burnable.burnFrom(address(0), 1);
    }

    function test_RevertsWhen_BurnAmountExceedesBalance() public {
        vm.expectRevert(ERC20_BurnExceedsBalance.selector);

        erc20Burnable.burnFrom(users.stranger, 1);
    }

    function test_EmitsEvent() public {
        IERC20Mintable(diamond).mint(users.owner, 100);

        vm.expectEmit(diamond);
        emit Transfer(users.owner, address(0), 100);

        erc20Burnable.burnFrom(users.owner, 100);
    }

    function test_BurnsTokens() public {
        IERC20Mintable(diamond).mint(users.owner, 100);

        erc20Burnable.burnFrom(users.owner, 100);

        assertEq(IERC20(diamond).balanceOf(users.owner), 0);
        assertEq(IERC20(diamond).totalSupply(), 0);
    }
}
