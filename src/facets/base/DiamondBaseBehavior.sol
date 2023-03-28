// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { DiamondBaseStorage } from "./DiamondBaseStorage.sol";

error DiamondBase_checkDiamondFactory_InvalidDiamondFactory();

library DiamondBaseBehavior {
    function checkDiamondFactory(address factory) internal view {
        if (diamondFactory() != factory) revert DiamondBase_checkDiamondFactory_InvalidDiamondFactory();
    }

    function diamondFactory() internal view returns (address) {
        return DiamondBaseStorage.layout().diamondFactory;
    }
}
