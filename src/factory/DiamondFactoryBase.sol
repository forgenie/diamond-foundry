// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { IDiamondFactoryBase } from "./IDiamondFactoryBase.sol";
import { Diamond } from "src/Diamond.sol";
import { IDiamondLoupe } from "src/facets/loupe/IDiamondLoupe.sol";

contract DiamondFactoryBase is IDiamondFactoryBase {
    function _createDiamond(Diamond.InitParams memory initParams) internal virtual returns (address diamond) {
        // slither-disable-start reentrancy-events
        diamond = address(new Diamond(initParams));
        if (!IDiamondLoupe(diamond).supportsInterface(type(IDiamondLoupe).interfaceId)) {
            revert DiamondFactory_LoupeNotSupported();
        }

        emit DiamondCreated(diamond, msg.sender);
        // slither-disable-end reentrancy-events
    }
}
