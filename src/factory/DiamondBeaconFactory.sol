// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { UpgradeableBeacon } from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import { BeaconProxy } from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";

abstract contract DiamondBeaconFactory is UpgradeableBeacon {
    constructor(address implementation) UpgradeableBeacon(implementation) {
        // solhint-disable-previous-line no-empty-blocks
    }

    function _deployBeaconProxy(bytes memory data, bytes32 salt) internal returns (address beaconProxy) {
        beaconProxy = address(new BeaconProxy{ salt: salt }(address(this), data));
    }
}
