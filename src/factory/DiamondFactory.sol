// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { DiamondFactoryBase } from "./DiamondFactoryBase.sol";
import { IDiamondFactory } from "./IDiamondFactory.sol";
import { Diamond } from "src/diamond/Diamond.sol";

contract DiamondFactory is IDiamondFactory, DiamondFactoryBase {
    /// @inheritdoc IDiamondFactory
    function deployDiamondClone(address diamond, Diamond.InitParams memory initDiamondCut) external returns (address) {
        return _deployDiamondClone(diamond, initDiamondCut);
    }

    /// @inheritdoc IDiamondFactory
    function deployDiamondClone(
        address diamond,
        bytes32 salt,
        Diamond.InitParams memory initDiamondCut
    )
        external
        returns (address)
    {
        return _deployDiamondClone(diamond, salt, initDiamondCut);
    }

    /// @inheritdoc IDiamondFactory
    function deployDiamondBeacon(
        address diamondBeacon,
        Diamond.InitParams memory initDiamondCut
    )
        external
        returns (address)
    {
        return _deployDiamondBeacon(diamondBeacon, initDiamondCut);
    }

    /// @inheritdoc IDiamondFactory
    function deployDiamondBeacon(
        address diamondBeacon,
        bytes32 salt,
        Diamond.InitParams memory initDiamondCut
    )
        external
        returns (address)
    {
        return _deployDiamondBeacon(diamondBeacon, salt, initDiamondCut);
    }
}
