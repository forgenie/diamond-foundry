// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Ownable, IERC173 } from "src/facets/ownable/Ownable.sol";
import { IOwnable2Step } from "./IOwnable2Step.sol";
import { Ownable2StepBehavior } from "./Ownable2StepBehavior.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";
import { Facet } from "src/facets/BaseFacet.sol";

abstract contract Ownable2Step is IOwnable2Step, Ownable {
    modifier onlyPendingOwner() {
        Ownable2StepBehavior.checkPendingOwner(_msgSender());
        _;
    }

    function __Ownable2Step_init() internal onlyInitializing {
        IntrospectionBehavior.addInterface(type(IOwnable2Step).interfaceId);
    }

    /// @inheritdoc IERC173
    function transferOwnership(address newOwner) public override onlyOwner {
        Ownable2StepBehavior.transferOwnership(_msgSender(), newOwner);
    }

    /// @inheritdoc IOwnable2Step
    function acceptOwnership() external onlyPendingOwner {
        Ownable2StepBehavior.acceptOwnership(_msgSender());
    }

    /// @inheritdoc IOwnable2Step
    function pendingOwner() external view returns (address) {
        return Ownable2StepBehavior.pendingOwner();
    }
}
