// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Initializable } from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import { Context } from "@openzeppelin/contracts/utils/Context.sol";

error BaseFacet_noDelegateCall_DelegateNotAllowed();

abstract contract BaseFacet is Initializable, Context {
    address private immutable __this = address(this);

    modifier noDelegateCall() {
        if (address(this) != __this) revert BaseFacet_noDelegateCall_DelegateNotAllowed();
        _;
    }

    /// @dev Prevents initializer from being called in the facet itself.
    constructor() {
        _disableInitializers();
    }
}
