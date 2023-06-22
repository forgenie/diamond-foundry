// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
import { BeaconProxy } from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import { IDiamond, Diamond } from "src/diamond/Diamond.sol";

abstract contract DiamondFactoryBase {
    function _deployDiamondClone(
        address implementation,
        Diamond.InitParams memory params
    )
        internal
        returns (address diamond)
    {
        diamond = Clones.clone(implementation);

        // slither-disable-next-line unused-return
        Address.functionCall(diamond, abi.encodeWithSelector(Diamond.initialize.selector, params));
    }

    function _deployDiamondClone(
        address implementation,
        bytes32 salt,
        Diamond.InitParams memory params
    )
        internal
        returns (address diamond)
    {
        diamond = Clones.cloneDeterministic(implementation, salt);

        // slither-disable-next-line unused-return
        Address.functionCall(diamond, abi.encodeWithSelector(Diamond.initialize.selector, params));
    }

    function _deployDiamondBeacon(
        address beacon,
        Diamond.InitParams memory initDiamondCut
    )
        internal
        returns (address diamond)
    {
        bytes memory initData = abi.encodeWithSelector(Diamond.initialize.selector, initDiamondCut);
        diamond = address(new BeaconProxy(beacon, initData));
    }

    function _deployDiamondBeacon(
        address beacon,
        bytes32 salt,
        Diamond.InitParams memory initDiamondCut
    )
        internal
        returns (address diamond)
    {
        bytes memory initData = abi.encodeWithSelector(Diamond.initialize.selector, initDiamondCut);
        diamond = address(new BeaconProxy{ salt: salt }(beacon, initData));
    }
}
