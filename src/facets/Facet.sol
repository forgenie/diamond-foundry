// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { Initializable } from "src/utils/Initializable.sol";
import { DelegateContext } from "src/utils/DelegateContext.sol";

abstract contract Facet is Initializable, DelegateContext {
    constructor() {
        _disableInitializers();
    }
}
