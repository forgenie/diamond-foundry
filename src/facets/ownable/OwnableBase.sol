// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { IERC173, IOwnableBase } from "./IERC173.sol";
import { OwnableStorage } from "./OwnableStorage.sol";

abstract contract OwnableBase is IOwnableBase {
    modifier onlyOwner() {
        if (msg.sender != _owner()) revert Ownable_CallerIsNotOwner();
        _;
    }

    function _owner() internal view returns (address) {
        return OwnableStorage.layout().owner;
    }

    function _transferOwnership(address newOwner) internal {
        if (newOwner == address(0)) revert Ownable_ZeroAddress();

        emit OwnershipTransferred(_owner(), newOwner);
        OwnableStorage.layout().owner = newOwner;
    }

    function _renounceOwnership() internal {
        emit OwnershipTransferred(_owner(), address(0));
        delete  OwnableStorage.layout().owner;
    }
}
