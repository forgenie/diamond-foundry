// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { ERC20MintableFacetTest } from "../erc20-mintable.t.sol";
import { IERC20 } from "src/facets/erc20/IERC20.sol";
import { Facet } from "src/facets/Facet.sol";

contract ERC20Mintable_mint is ERC20MintableFacetTest {
    function test_RevertsWhen_CallerIsUnauthorized() public {
        changePrank(users.stranger);

        vm.expectRevert(Facet.CallerIsNotAuthorized.selector);

        erc20Mintable.mint(address(1), 100);
    }

    function test_RevertsWhen_RecipientIsZeroAddress() public {
        vm.expectRevert(ERC20_MintToZeroAddress.selector);

        erc20Mintable.mint(address(0), 100);
    }

    function test_EmitsEvent() public {
        address to = address(1);
        uint256 value = 100;

        vm.expectEmit(diamond);
        emit Transfer(address(0), to, value);

        erc20Mintable.mint(to, value);
    }

    function test_MintsTokens() public {
        address to = address(1);
        uint256 value = 100;

        erc20Mintable.mint(to, value);

        assertEq(IERC20(diamond).balanceOf(to), value);
        assertEq(IERC20(diamond).totalSupply(), value);
    }
}
