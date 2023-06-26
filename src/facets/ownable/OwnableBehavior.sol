// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { OwnableStorage } from "./OwnableStorage.sol";

error Ownable_ZeroAddress();
error Ownable_NotOwner(address account);

library OwnableBehavior {
    function owner() internal view returns (address) {
        return OwnableStorage.layout().owner;
    }

    function checkOwner(address account) internal view {
        if (account != owner()) revert Ownable_NotOwner(account);
    }

    function transferOwnership(address newOwner) internal {
        if (newOwner == address(0)) revert Ownable_ZeroAddress();

        OwnableStorage.layout().owner = newOwner;
    }

    function renounceOwnership() internal {
        OwnableStorage.layout().owner = address(0);
    }
}
