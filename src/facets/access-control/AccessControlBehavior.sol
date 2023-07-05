// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { AccessControlStorage } from "./AccessControlStorage.sol";

library AccessControlBehavior {
    function setRoleCapability(uint8 role, bytes4 functionSig, bool enabled) internal {
        if (enabled) {
            AccessControlStorage.layout().allowedRoles[functionSig] |= bytes32(1 << role);
        } else {
            AccessControlStorage.layout().allowedRoles[functionSig] &= ~bytes32(1 << role);
        }
    }

    function setUserRole(address user, uint8 role, bool enabled) internal {
        if (enabled) {
            AccessControlStorage.layout().userRoles[user] |= bytes32(1 << role);
        } else {
            AccessControlStorage.layout().userRoles[user] &= ~bytes32(1 << role);
        }
    }

    function canCall(address user, bytes4 functionSig) internal view returns (bool) {
        return userRoles(user) & allowedRoles(functionSig) != bytes32(0);
    }

    function userRoles(address user) internal view returns (bytes32) {
        return AccessControlStorage.layout().userRoles[user];
    }

    function allowedRoles(bytes4 functionSig) internal view returns (bytes32) {
        return AccessControlStorage.layout().allowedRoles[functionSig];
    }

    function hasRole(address user, uint8 role) internal view returns (bool) {
        return userRoles(user) & bytes32(1 << role) != bytes32(0);
    }

    function roleHasCapability(uint8 role, bytes4 functionSig) internal view returns (bool) {
        return allowedRoles(functionSig) & bytes32(1 << role) != bytes32(0);
    }
}
