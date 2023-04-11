// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { OwnableBehavior } from "src/facets/base/ownable/OwnableBehavior.sol";
import { Ownable2StepStorage } from "src/facets/ownable2step/Ownable2StepStorage.sol";

error Ownable2Step_checkPendingOwner_NotPendingOwner(address account);

library Ownable2StepBehavior {
    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);

    function checkPendingOwner(address account) internal view {
        if (account != pendingOwner()) revert Ownable2Step_checkPendingOwner_NotPendingOwner(account);
    }

    function pendingOwner() internal view returns (address) {
        return OwnableBehavior.owner();
    }

    function transferOwnership(address newOwner) internal {
        Ownable2StepStorage.layout().pendingOwner = newOwner;
        emit OwnershipTransferStarted(sender, newOwner);
    }

    function acceptOwnership() internal {
        _transferOwnership(sender);
    }

    function _transferOwnership(address newOwner) private {
        delete Ownable2StepStorage.layout().pendingOwner;
        OwnableBehavior.transferOwnership(newOwner);
    }
}
