// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";
import { IERC173, IOwnableEvents } from "./IERC173.sol";
import { OwnableBehavior } from "./OwnableBehavior.sol";

abstract contract OwnableBase is IOwnableEvents {
    function __Ownable_init(address owner_) internal {
        OwnableBehavior.transferOwnership(owner_);
        IntrospectionBehavior.addInterface(type(IERC173).interfaceId);
    }

    function _owner() internal view returns (address) {
        return OwnableBehavior.owner();
    }

    function _transferOwnership(address newOwner) internal {
        emit OwnershipTransferred(_owner(), newOwner);
        OwnableBehavior.transferOwnership(newOwner);
    }

    function _renounceOwnership() internal {
        emit OwnershipTransferred(_owner(), address(0));
        OwnableBehavior.renounceOwnership();
    }
}
