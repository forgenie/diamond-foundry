// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IAccessControlEvents } from "./IAccessControl.sol";
import { AccessControlBehavior } from "./AccessControlBehavior.sol";

abstract contract AccessControlBase is IAccessControlEvents {
    function _setFunctionAccess(bytes4 functionSig, uint8 role, bool enabled) internal {
        AccessControlBehavior.setFunctionAccess(functionSig, role, enabled);

        emit FunctionAccessChanged(functionSig, role, enabled);
    }

    function _setUserRole(address user, uint8 role, bool enabled) internal {
        AccessControlBehavior.setUserRole(user, role, enabled);

        emit UserRoleUpdated(user, role, enabled);
    }

    function _canCall(address user, bytes4 functionSig) internal view returns (bool) {
        return AccessControlBehavior.canCall(user, functionSig);
    }

    function _userRoles(address user) internal view returns (bytes32) {
        return AccessControlBehavior.userRoles(user);
    }

    function _functionRoles(bytes4 functionSig) internal view returns (bytes32) {
        return AccessControlBehavior.functionRoles(functionSig);
    }

    function _hasRole(address user, uint8 role) internal view returns (bool) {
        return AccessControlBehavior.hasRole(user, role);
    }

    function _roleHasAccess(uint8 role, bytes4 functionSig) internal view returns (bool) {
        return AccessControlBehavior.roleHasAccess(role, functionSig);
    }
}
