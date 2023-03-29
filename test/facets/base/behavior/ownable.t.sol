// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IERC173 } from "src/facets/base/ownable/IERC173.sol";
import { DiamondBaseFacetTest } from "test/facets/base/DiamondBase.t.sol";

import {
    Ownable_transferOwnership_ZeroAddress,
    Ownable_checkOwner_NotOwner
} from "src/facets/base/ownable/OwnableBehavior.sol";

contract OwnableTest is DiamondBaseFacetTest {
    IERC173 public ownable;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function setUp() public override {
        super.setUp();

        ownable = IERC173(diamondBase);
        vm.startPrank(users.owner);
    }

    /**
     * ----------------------------------------- transferOwnership -----------------------------------------
     */
    function test_RevertsWhen_CallerIsNotOwner() public {
        changePrank(users.stranger);

        vm.expectRevert(abi.encodeWithSelector(Ownable_checkOwner_NotOwner.selector, users.stranger));

        ownable.transferOwnership(users.stranger);
    }

    function test_RevertsWhen_NewOwnerIsZeroAddress() public {
        vm.expectRevert(Ownable_transferOwnership_ZeroAddress.selector);

        ownable.transferOwnership(address(0));
    }

    function test_EmitsEvent() public {
        expectEmit(address(diamondBase));
        emit OwnershipTransferred(users.owner, users.stranger);

        ownable.transferOwnership(users.stranger);
    }

    /**
     * ----------------------------------------- owner -----------------------------------------
     */
    function test_ReturnsNewOwner() public {
        ownable.transferOwnership(users.stranger);

        assertEq(ownable.owner(), users.stranger);
    }
}
