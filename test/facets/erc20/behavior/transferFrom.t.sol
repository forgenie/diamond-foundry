// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { ERC20FacetTest } from "../erc20.t.sol";

contract ERC20_transferFrom is ERC20FacetTest {
    function test_RevertsWhen_InsufficientAllowance() public {
        address owner = address(1);
        address spender = address(2);
        address recipient = address(3);
        uint256 amount = 1e18;
        changePrank(spender);

        vm.expectRevert(ERC20_InsufficientAllowance.selector);

        erc20.transferFrom(owner, recipient, amount);
    }

    function testFuzz_WhenSufficientAllowance_AllowanceDecreases(uint256 amount, uint256 transferAmount) public {
        vm.assume(amount >= transferAmount);

        address owner = address(1);
        address spender = address(2);
        address recipient = address(3);
        deal(address(erc20), owner, amount);
        changePrank(owner);
        erc20.approve(spender, amount);
        changePrank(spender);

        erc20.transferFrom(owner, recipient, transferAmount);

        assertEq(erc20.allowance(owner, spender), amount - transferAmount);
    }

    function testFuzz_TransfersTokens(uint256 amount) public {
        address owner = address(1);
        address spender = address(2);
        address recipient = address(3);
        deal(address(erc20), owner, amount);
        changePrank(owner);
        erc20.approve(spender, amount);
        changePrank(spender);

        erc20.transferFrom(owner, recipient, amount);

        assertEq(erc20.balanceOf(owner), 0);
        assertEq(erc20.balanceOf(recipient), amount);
    }
}
