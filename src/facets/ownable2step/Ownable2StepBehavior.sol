// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { OwnableBehavior } from "src/facets/ownable/OwnableBehavior.sol";
import { Ownable2StepStorage } from "src/facets/ownable2step/Ownable2StepStorage.sol";

error Ownable2Step_checkPendingOwner_NotPendingOwner(address account);

library Ownable2StepBehavior {
    function checkPendingOwner(address account) internal view {
        if (account != pendingOwner()) revert Ownable2Step_checkPendingOwner_NotPendingOwner(account);
    }

    function pendingOwner() internal view returns (address) {
        return Ownable2StepStorage.layout().pendingOwner;
    }

    function setPendingOwner(address newOwner) internal {
        Ownable2StepStorage.layout().pendingOwner = newOwner;
    }

    function acceptOwnership() internal returns (address newOwner) {
        newOwner = pendingOwner();

        OwnableBehavior.transferOwnership(newOwner);

        delete Ownable2StepStorage.layout().pendingOwner;
    }
}
