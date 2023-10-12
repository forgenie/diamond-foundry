// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.20;

import { Facet } from "src/facets/Facet.sol";
import { IOwnable2Step } from "./IOwnable2Step.sol";
import { Ownable2StepBase } from "./Ownable2StepBase.sol";
import { IOwnable } from "src/facets/ownable/IOwnable.sol";

contract Ownable2StepFacet is IOwnable, IOwnable2Step, Ownable2StepBase, Facet {
    function Ownable2Step_init() external onlyInitializing {
        _addInterface(type(IOwnable2Step).interfaceId);
    }

    /// @inheritdoc IOwnable2Step
    function transferOwnership(address newOwner) external override(IOwnable, IOwnable2Step) onlyOwner {
        _startTransferOwnership(msg.sender, newOwner);
    }

    /// @inheritdoc IOwnable2Step
    function acceptOwnership() external onlyPendingOwner {
        _acceptOwnership();
    }

    /// @inheritdoc IOwnable
    function owner() external view returns (address) {
        return _owner();
    }

    /// @inheritdoc IOwnable2Step
    function pendingOwner() external view returns (address) {
        return _pendingOwner();
    }
}
