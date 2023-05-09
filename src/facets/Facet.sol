// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Initializable } from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import { Context } from "@openzeppelin/contracts/utils/Context.sol";
import { DelegateCall } from "src/utils/DelegateCall.sol";

// todo: delete context
abstract contract Facet is Initializable, Context, DelegateCall {
    constructor() {
        _disableInitializers();
    }
}
