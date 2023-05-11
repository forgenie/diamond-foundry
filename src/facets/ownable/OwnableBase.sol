// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Initializable } from "src/utils/Initializable.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";
import { IERC173, IOwnableEvents } from "./IERC173.sol";
import { OwnableBehavior } from "./OwnableBehavior.sol";

abstract contract OwnableBase is IOwnableEvents, Initializable {
    modifier onlyOwner() {
        OwnableBehavior.checkOwner(msg.sender);
        _;
    }

    function __Ownable_init(address owner_) internal onlyInitializing {
        OwnableBehavior.transferOwnership(owner_);
        IntrospectionBehavior.addInterface(type(IERC173).interfaceId);
    }

    function _owner() internal view returns (address) {
        return OwnableBehavior.owner();
    }

    function _transferOwnership(address newOwner) internal {
        address oldOwner = _owner();

        OwnableBehavior.transferOwnership(newOwner);

        emit OwnershipTransferred(oldOwner, newOwner);
    }

    function _renounceOwnership() internal {
        address oldOwner = _owner();

        OwnableBehavior.renounceOwnership();

        emit OwnershipTransferred(oldOwner, address(0));
    }
}
