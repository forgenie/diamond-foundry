// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
import { BeaconProxy } from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import { IDiamondFactory } from "./IDiamondFactory.sol";

abstract contract DiamondFactory {
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

    function _deployClone(address implementation) internal returns (address clone) {
        clone = Clones.clone(implementation);
    }
}
