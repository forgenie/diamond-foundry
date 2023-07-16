// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { IOwnableBase } from "src/facets/ownable/IERC173.sol";
import { IOwnable2Step, IOwnable2StepBase } from "./IOwnable2Step.sol";
import { OwnableBase } from "src/facets/ownable/OwnableBase.sol";
import { Ownable2StepStorage } from "src/facets/ownable2step/Ownable2StepStorage.sol";

abstract contract Ownable2StepBase is IOwnable2StepBase, IOwnableBase, OwnableBase {
    modifier onlyPendingOwner() {
        if (msg.sender != _pendingOwner()) revert Ownable2Step_NotPendingOwner(msg.sender);
        _;
    }

    function _startTransferOwnership(address owner, address pendingOwner) internal {
        Ownable2StepStorage.layout().pendingOwner = pendingOwner;
        emit OwnershipTransferStarted(owner, pendingOwner);
    }

    function _acceptOwnership() internal {
        address newOwner = _pendingOwner();

        emit OwnershipTransferred(_owner(), newOwner);
        _transferOwnership(newOwner);

        delete Ownable2StepStorage.layout().pendingOwner;
    }

    function _pendingOwner() internal view returns (address) {
        return Ownable2StepStorage.layout().pendingOwner;
    }
}
