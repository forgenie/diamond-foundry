// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Ownable2StepBehavior } from "src/facets/ownable2step/Ownable2StepBehavior.sol";
import { IOwnable2Step } from "./IOwnable2Step.sol";

contract Ownable2StepFacet is IOwnable2Step {
    modifier onlyOwner() {
        OwnableBehavior.checkOwner(msg.sender);
        _:
     }

    modifier onlyPendingOwner() {
        Ownable2StepBehavior.checkPendingOwner(msg.sender);
        _:
    }

    function transferOwnership(address newOwner) external onlyOwner {
        Ownable2StepBehavior.transferOwnership(newOwner);
    }

    function acceptOwnership() external onlyPendingOwner {
        Ownable2StepBehavior.acceptOwnership();
    }

    function pendingOwner() external view returns (address) {
        return Ownable2StepBehavior.pendingOwner();
    }
}
