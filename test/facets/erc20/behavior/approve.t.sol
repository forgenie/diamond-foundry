// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { ERC20FacetTest } from "../erc20.t.sol";

contract ERC20_approve is ERC20FacetTest {
    function test_RevertsWhen_OwnerIsZeroAddress() public {
        address spender = address(1);
        uint256 amount = 1e18;
        changePrank(address(0));

        vm.expectRevert(ERC20_ApproveFromZeroAddress.selector);

        erc20.approve(spender, amount);
    }

    function test_RevertsWhen_SpenderIsZeroAddress() public {
        uint256 amount = 1e18;

        vm.expectRevert(ERC20_ApproveToZeroAddress.selector);

        erc20.approve(address(0), amount);
    }

    function testFuzz_EmitsEvent(address owner, address spender, uint256 amount) public {
        vm.assume(owner != address(0) && spender != address(0));
        changePrank(owner);

        vm.expectEmit(diamond);
        emit Approval(owner, spender, amount);

        erc20.approve(spender, amount);
    }

    function testFuzz_ReturnsAllowance(address owner, address spender, uint256 amount) public {
        vm.assume(owner != address(0) && spender != address(0));
        changePrank(owner);

        erc20.approve(spender, amount);

        assertEq(erc20.allowance(owner, spender), amount);
    }
}
