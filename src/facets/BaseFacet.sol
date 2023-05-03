// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Initializable } from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import { Context } from "@openzeppelin/contracts/utils/Context.sol";
import { DelegateCall } from "src/utils/DelegateCall.sol";

// solhint-disable-next-line no-empty-blocks
abstract contract Facet is Initializable, Context, DelegateCall { }

abstract contract BaseFacet is Facet {
    /// @dev Prevents initializer from being called in the facet itself.
    constructor() {
        _disableInitializers();
    }

    /// @dev must contain initializer
}
