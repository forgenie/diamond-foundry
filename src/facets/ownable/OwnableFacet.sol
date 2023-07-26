// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { Facet } from "src/facets/Facet.sol";
import { IERC173 } from "./IERC173.sol";
import { OwnableBase } from "./OwnableBase.sol";

contract OwnableFacet is IERC173, OwnableBase, Facet {
    function Ownable_init(address owner_) external onlyInitializing {
        _transferOwnership(owner_);
        _addInterface(type(IERC173).interfaceId);
    }

    /// @inheritdoc IERC173
    function owner() external view returns (address) {
        return _owner();
    }

    /// @inheritdoc IERC173
    function transferOwnership(address newOwner) external onlyOwner {
        _transferOwnership(newOwner);
    }
}
