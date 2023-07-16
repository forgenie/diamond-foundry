// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { Facet } from "src/facets/Facet.sol";
import { IOwnable2Step } from "./IOwnable2Step.sol";
import { Ownable2StepBase } from "./Ownable2StepBase.sol";
import { IERC173 } from "src/facets/ownable/IERC173.sol";
import { OwnableBase } from "src/facets/ownable/OwnableBase.sol";

contract Ownable2StepFacet is IERC173, IOwnable2Step, Ownable2StepBase, Facet {
    function Ownable2Step_init() external onlyInitializing {
        _addInterface(type(IOwnable2Step).interfaceId);
    }

    /// @inheritdoc IOwnable2Step
    function transferOwnership(address newOwner) external override(IERC173, IOwnable2Step) onlyOwner {
        _startTransferOwnership(msg.sender, newOwner);
    }

    /// @inheritdoc IOwnable2Step
    function acceptOwnership() external onlyPendingOwner {
        _acceptOwnership();
    }

    /// @inheritdoc IERC173
    function owner() external view returns (address) {
        return _owner();
    }

    /// @inheritdoc IOwnable2Step
    function pendingOwner() external view returns (address) {
        return _pendingOwner();
    }
}
