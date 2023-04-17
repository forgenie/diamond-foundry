// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IERC173 } from "./IERC173.sol";
import { OwnableBehavior } from "./OwnableBehavior.sol";
import { Facet } from "src/facets/BaseFacet.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";

abstract contract Ownable is IERC173, Facet {
    modifier onlyOwner() {
        OwnableBehavior.checkOwner(_msgSender());
        _;
    }

    function __Ownable_init(address owner_) internal onlyInitializing {
        OwnableBehavior.transferOwnership(owner_);
        IntrospectionBehavior.addInterface(type(IERC173).interfaceId);
    }

    /// @inheritdoc IERC173
    function owner() public view returns (address) {
        return OwnableBehavior.owner();
    }

    /// @inheritdoc IERC173
    function transferOwnership(address newOwner) public onlyOwner {
        OwnableBehavior.transferOwnership(newOwner);
    }
}
