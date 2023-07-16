// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { AccessControlStorage } from "./AccessControlStorage.sol";

library AccessControlBehavior {
    function setFunctionAccess(bytes4 functionSig, uint8 role, bool enabled) internal {
        if (enabled) {
            AccessControlStorage.layout().functionRoles[functionSig] |= bytes32(1 << role);
        } else {
            AccessControlStorage.layout().functionRoles[functionSig] &= ~bytes32(1 << role);
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
        return userRoles(user) & functionRoles(functionSig) != bytes32(0);
    }

    function userRoles(address user) internal view returns (bytes32) {
        return AccessControlStorage.layout().userRoles[user];
    }

    function functionRoles(bytes4 functionSig) internal view returns (bytes32) {
        return AccessControlStorage.layout().functionRoles[functionSig];
    }

    function hasRole(address user, uint8 role) internal view returns (bool) {
        return userRoles(user) & bytes32(1 << role) != bytes32(0);
    }

    function roleHasAccess(uint8 role, bytes4 functionSig) internal view returns (bool) {
        return functionRoles(functionSig) & bytes32(1 << role) != bytes32(0);
    }
}
