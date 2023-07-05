// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { Initializable } from "src/utils/Initializable.sol";
import { DelegateCall } from "src/utils/DelegateCall.sol";

abstract contract Facet is Initializable, DelegateCall {
    constructor() {
        _disableInitializers();
    }
}
