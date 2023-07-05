// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
import { BeaconProxy } from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import { IDiamond, Diamond } from "src/diamond/Diamond.sol";

abstract contract DiamondFactoryBase {
    function _deployDiamondClone(address diamond, Diamond.InitParams memory params) internal returns (address clone) {
        clone = Clones.clone(diamond);

        // slither-disable-next-line unused-return
        Address.functionCall(clone, abi.encodeWithSelector(Diamond.initialize.selector, params));
    }

    function _deployDiamondClone(
        address diamond,
        bytes32 salt,
        Diamond.InitParams memory params
    )
        internal
        returns (address clone)
    {
        clone = Clones.cloneDeterministic(diamond, salt);

        // slither-disable-next-line unused-return
        Address.functionCall(clone, abi.encodeWithSelector(Diamond.initialize.selector, params));
    }

    function _deployDiamondBeacon(
        address diamondBeacon,
        Diamond.InitParams memory initDiamondCut
    )
        internal
        returns (address beaconProxy)
    {
        bytes memory initData = abi.encodeWithSelector(Diamond.initialize.selector, initDiamondCut);
        beaconProxy = address(new BeaconProxy(diamondBeacon, initData));
    }

    function _deployDiamondBeacon(
        address diamondBeacon,
        bytes32 salt,
        Diamond.InitParams memory initDiamondCut
    )
        internal
        returns (address beaconProxy)
    {
        bytes memory initData = abi.encodeWithSelector(Diamond.initialize.selector, initDiamondCut);
        beaconProxy = address(new BeaconProxy{ salt: salt }(diamondBeacon, initData));
    }
}
