// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { Initializable } from "src/utils/Initializable.sol";
import { DelegateContext } from "src/utils/DelegateContext.sol";
import { DiamondLoupeBase } from "src/facets/loupe/DiamondLoupeBase.sol";

abstract contract Facet is Initializable, DelegateContext, DiamondLoupeBase {
    constructor() {
        _disableInitializers();
    }

    // Consider hardcoding interfaceIds in a noDelegateCall function.
    // function supportedInterfaces() public noDelegateCall view virtual returns (bytes4[] memory);
}
