// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { OwnableFacetTest } from "../ownable.t.sol";

import {
    OwnableBehavior,
    Ownable_checkOwner_NotOwner,
    Ownable_transferOwnership_ZeroAddress
} from "src/facets/ownable/OwnableBehavior.sol";

contract Ownable_transferOwnership is OwnableFacetTest {
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
        vm.expectEmit();
        emit OwnershipTransferred(users.owner, users.stranger);

        ownable.transferOwnership(users.stranger);
    }

    function test_TransfersOwner() public {
        ownable.transferOwnership(users.stranger);

        assertEq(ownable.owner(), users.stranger);
    }
}
