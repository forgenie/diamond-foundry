// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { IOwnableEvents } from "src/facets/ownable/IERC173.sol";
import { IOwnable2Step, IOwnable2StepEvents } from "./IOwnable2Step.sol";
import { OwnableBehavior } from "src/facets/ownable/OwnableBehavior.sol";
import { Ownable2StepBehavior } from "./Ownable2StepBehavior.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";

abstract contract Ownable2StepBase is IOwnable2StepEvents, IOwnableEvents {
    modifier onlyPendingOwner() {
        Ownable2StepBehavior.checkPendingOwner(msg.sender);
        _;
    }

    function __Ownable2Step_init() internal {
        IntrospectionBehavior.addInterface(type(IOwnable2Step).interfaceId);
    }

    function _transferOwnership(address owner, address pendingOwner) internal {
        Ownable2StepBehavior.setPendingOwner(pendingOwner);

        emit OwnershipTransferStarted(owner, pendingOwner);
    }

    function _acceptOwnership() internal {
        address previousOwner = OwnableBehavior.owner();
        address newOwner = Ownable2StepBehavior.acceptOwnership();

        emit OwnershipTransferred(previousOwner, newOwner);
    }

    function _pendingOwner() internal view returns (address) {
        return Ownable2StepBehavior.pendingOwner();
    }
}
