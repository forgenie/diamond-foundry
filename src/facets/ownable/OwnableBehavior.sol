// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

// implements interface
import { IERC173 } from "./IERC173.sol";

// uses storage
import { OwnableStorage } from "./OwnableStorage.sol";

error Ownable_transferOwnership_ZeroAddress();
error Ownable_checkOwner_NotOwner(address account);

library OwnableBehavior {
    /// IERC173 event
    /// Cannot emit events from other interfaces in a library
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function owner() internal view returns (address) {
        return OwnableStorage.layout().owner;
    }

    function checkOwner(address account) internal view {
        if (account != owner()) revert Ownable_checkOwner_NotOwner(account);
    }

    function transferOwnership(address newOwner) internal {
        if (newOwner == address(0)) revert Ownable_transferOwnership_ZeroAddress();

        _transferOwnership(newOwner);
    }

    function renounceOwnership() internal {
        _transferOwnership(address(0));
    }

    function _transferOwnership(address newOwner) private {
        address oldOwner = owner();
        OwnableStorage.layout().owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}
