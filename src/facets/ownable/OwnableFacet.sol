// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.20;

import { Facet } from "src/facets/Facet.sol";
import { IOwnable } from "./IOwnable.sol";
import { OwnableBase } from "./OwnableBase.sol";

contract OwnableFacet is IOwnable, OwnableBase, Facet {
    function Ownable_init(address owner_) external onlyInitializing {
        _transferOwnership(owner_);
        _addInterface(type(IOwnable).interfaceId);
    }

    /// @inheritdoc IOwnable
    function owner() external view returns (address) {
        return _owner();
    }

    /// @inheritdoc IOwnable
    function transferOwnership(address newOwner) external onlyOwner {
        _transferOwnership(newOwner);
    }
}
