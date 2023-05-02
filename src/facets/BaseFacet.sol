// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Initializable } from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import { Context } from "@openzeppelin/contracts/utils/Context.sol";
import { DelegateCall } from "src/utils/DelegateCall.sol";

// solhint-disable-next-line no-empty-blocks
abstract contract Facet is Initializable, Context, DelegateCall {
    constructor() {
        _disableInitializers();
    }
}

abstract contract BaseFacet is Facet { }
