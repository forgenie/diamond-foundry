// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { DiamondFactoryBase } from "./DiamondFactoryBase.sol";
import { IDiamondFactory } from "./IDiamondFactory.sol";
import { Diamond } from "src/diamond/Diamond.sol";

contract DiamondFactory is IDiamondFactory, DiamondFactoryBase {
    /// @inheritdoc IDiamondFactory
    function deployDiamondClone(
        address implementation,
        Diamond.InitParams memory initDiamondCut
    )
        external
        returns (address diamond)
    {
        diamond = _deployDiamondClone(implementation, initDiamondCut);
    }

    /// @inheritdoc IDiamondFactory
    function deployDiamondClone(
        address implementation,
        bytes32 salt,
        Diamond.InitParams memory initDiamondCut
    )
        external
        returns (address diamond)
    {
        diamond = _deployDiamondClone(implementation, salt, initDiamondCut);
    }

    /// @inheritdoc IDiamondFactory
    function deployDiamondBeacon(
        address beacon,
        Diamond.InitParams memory initDiamondCut
    )
        external
        returns (address diamond)
    {
        diamond = _deployDiamondBeacon(beacon, initDiamondCut);
    }

    /// @inheritdoc IDiamondFactory
    function deployDiamondBeacon(
        address beacon,
        bytes32 salt,
        Diamond.InitParams memory initDiamondCut
    )
        external
        returns (address diamond)
    {
        diamond = _deployDiamondBeacon(beacon, salt, initDiamondCut);
    }
}
