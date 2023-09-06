// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Diamond } from "src/diamond/Diamond.sol";
import { DiamondFactoryBase } from "./DiamondFactoryBase.sol";
import { IDiamondFactory } from "./IDiamondFactory.sol";

/**
 * @notice Factory that deploys new diamonds.
 * NOTE: This contract is structured so that it can be a facet itself.
 */
contract DiamondFactory is IDiamondFactory, DiamondFactoryBase {
    /// @inheritdoc IDiamondFactory
    function createDiamond(Diamond.InitParams calldata initParams) external returns (address diamond) {
        diamond = _createDiamond(initParams);
    }
}
