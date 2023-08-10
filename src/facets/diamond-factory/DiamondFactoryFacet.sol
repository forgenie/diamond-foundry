// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Diamond } from "src/diamond/Diamond.sol";
import { DiamondFactoryBase } from "./DiamondFactoryBase.sol";
import { IDiamondFactory } from "./IDiamondFactory.sol";

contract DiamondFactoryFacet is IDiamondFactory, DiamondFactoryBase {
    /// @inheritdoc IDiamondFactory
    function createDiamond(Diamond.InitParams calldata initParams) external returns (address diamond) {
        diamond = _createDiamond(initParams);
    }
}
