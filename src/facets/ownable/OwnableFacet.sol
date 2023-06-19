// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Facet } from "src/facets/Facet.sol";
import { IERC173 } from "./IERC173.sol";
import { OwnableBase } from "./OwnableBase.sol";

contract OwnableFacet is IERC173, OwnableBase, Facet {
    function initialize(address owner_) external onlyInitializing {
        __Ownable_init(owner_);
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
