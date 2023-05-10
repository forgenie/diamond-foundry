// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Context } from "@openzeppelin/contracts/utils/Context.sol";
import { Initializable } from "src/utils/Initializable.sol";
import { DelegateCall } from "src/utils/DelegateCall.sol";

// todo: delete context
abstract contract Facet is Initializable, Context, DelegateCall {
    constructor() {
        _disableInitializers();
    }
}
