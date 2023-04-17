// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Initializable } from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import { Context } from "@openzeppelin/contracts/utils/Context.sol";

error BaseFacet_noDelegateCall_DelegateNotAllowed();

abstract contract Facet is Initializable, Context {
    address private immutable _this = address(this);

    modifier noDelegateCall() {
        if (address(this) != _this) revert BaseFacet_noDelegateCall_DelegateNotAllowed();
        _;
    }
}

abstract contract BaseFacet is Facet {
    /// @dev Prevents initializer from being called in the facet itself.
    constructor() {
        _disableInitializers();
    }

    /// @dev must contain initializer
}
