// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { OwnableBehavior } from "src/facets/base/ownable/OwnableBehavior.sol";
import { Ownable2StepBehavior } from "src/facets/ownable2step/Ownable2StepBehavior.sol";
import { IOwnable2Step } from "./IOwnable2Step.sol";

<<<<<<< HEAD
contract Ownable2StepFacet is IOwnable2Step {
    modifier onlyOwner() {
        OwnableBehavior.checkOwner(msg.sender);
        _;
    }

    modifier onlyPendingOwner() {
        Ownable2StepBehavior.checkPendingOwner(msg.sender);
        _;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        Ownable2StepBehavior.transferOwnership(msg.sender, newOwner);
    }

    function acceptOwnership() external onlyPendingOwner {
        Ownable2StepBehavior.acceptOwnership(msg.sender);
    }

    function pendingOwner() external view returns (address) {
        return Ownable2StepBehavior.pendingOwner();
=======
contract Ownable2StepFacet is Ownable2Step {
    function initialize() public initializer {
        __Ownable2Step_init();
    }
}

contract Ownable2StepBaseFacet is Ownable2Step {
    function initialize(address owner_) public initializer {
        __Ownable_init(owner_);
        __Ownable2Step_init();
>>>>>>> 03db915 (fix: slither)
    }
}
