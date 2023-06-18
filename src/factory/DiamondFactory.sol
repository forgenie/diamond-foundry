// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
import { BeaconProxy } from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import { IDiamondFactory } from "./IDiamondFactory.sol";
import { IDiamond, Diamond } from "src/diamond/Diamond.sol";

abstract contract DiamondFactory is IDiamondFactory {
    function _deployBeaconProxy(
        address beacon,
        bytes memory data,
        bytes32 salt
    )
        internal
        returns (address beaconProxy)
    {
        beaconProxy = address(new BeaconProxy{ salt: salt }(beacon, data));
    }

    function _deployCloneAndCall(address implementation, bytes memory initData) internal returns (address clone) {
        clone = Clones.clone(implementation);
        Address.functionCall(clone, initData);
    }

    function _deployDiamondClone(
        address implementation,
        Diamond.InitParams memory params
    )
        internal
        returns (address diamond)
    {
        diamond = _deployCloneAndCall(implementation, abi.encodeWithSelector(Diamond.initialize.selector, params));
    }

    function _deployDiamondBeacon() internal returns (address diamond) {
        // todo: deploy diamond beacon
    }
}
