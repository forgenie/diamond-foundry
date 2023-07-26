// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { ERC20FacetTest } from "../erc20.t.sol";

contract ERC20_transfer is ERC20FacetTest {
    function test_RevertsWhen_SenderIsZeroAddress() public {
        address recipient = address(1);
        uint256 amount = 1e18;
        changePrank(address(0));

        vm.expectRevert(ERC20_TransferFromZeroAddress.selector);

        erc20.transfer(recipient, amount);
    }

    function test_RevertsWhen_RecipientIsZeroAddress() public {
        uint256 amount = 1e18;

        vm.expectRevert(ERC20_TransferToZeroAddress.selector);

        erc20.transfer(address(0), amount);
    }

    function test_RevertsWhen_InsufficientBalance() public {
        address recipient = address(1);
        address sender = address(2);
        uint256 amount = 1e18;
        changePrank(sender);

        vm.expectRevert(ERC20_TransferExceedsBalance.selector);

        erc20.transfer(recipient, amount);
    }

    function test_RevertsWhen_TransferToSelf() public {
        address sender = address(1);
        uint256 amount = 1e18;
        changePrank(sender);

        vm.expectRevert(ERC20_TransferToSelf.selector);

        erc20.transfer(sender, amount);
    }

    function testFuzz_EmitsEvent(uint256 amount) public {
        address sender = address(1);
        address recipient = address(2);
        changePrank(sender);
        deal(address(erc20), sender, amount);

        vm.expectEmit(diamond);
        emit Transfer(sender, recipient, amount);

        erc20.transfer(recipient, amount);
    }

    function testFuzz_ReturnsBalanceOf(uint256 amount) public {
        address sender = address(1);
        address recipient = address(2);
        changePrank(sender);
        deal(address(erc20), sender, amount);

        assertTrue(erc20.transfer(recipient, amount));

        assertEq(erc20.balanceOf(recipient), amount);
        assertEq(erc20.balanceOf(sender), 0);
    }
}
