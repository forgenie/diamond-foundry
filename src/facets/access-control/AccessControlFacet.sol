// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { Facet } from "src/facets/Facet.sol";
import { AccessControlBase } from "./AccessControlBase.sol";
import { IAccessControl } from "./IAccessControl.sol";

error AccessControl_CannotRemoveAdminCapability();

contract AccessControlFacet is IAccessControl, AccessControlBase, Facet {
    uint8 public constant DEFAULT_ADMIN_ROLE = 0;

    function AccessControl_init(address roleAdmin) external onlyInitializing {
        _setUserRole(roleAdmin, DEFAULT_ADMIN_ROLE, true);
        _setRoleCapability(DEFAULT_ADMIN_ROLE, this.setRoleCapability.selector, true);
        _setRoleCapability(DEFAULT_ADMIN_ROLE, this.setUserRole.selector, true);
    }

    function setRoleCapability(uint8 role, bytes4 functionSig, bool enabled) external onlyAuthorized {
        if (
            role == DEFAULT_ADMIN_ROLE && enabled == false
                && (functionSig == this.setRoleCapability.selector || functionSig == this.setUserRole.selector)
        ) {
            revert AccessControl_CannotRemoveAdminCapability();
        }

        _setRoleCapability(role, functionSig, enabled);
    }

    function setUserRole(address user, uint8 role, bool enabled) external onlyAuthorized {
        _setUserRole(user, role, enabled);
    }

    function canCall(address user, bytes4 functionSig) external view returns (bool) {
        return _canCall(user, functionSig);
    }

    function userRoles(address user) external view returns (bytes32) {
        return _userRoles(user);
    }

    function allowedRoles(bytes4 functionSig) external view returns (bytes32) {
        return _allowedRoles(functionSig);
    }

    function hasRole(address user, uint8 role) external view returns (bool) {
        return _hasRole(user, role);
    }

    function roleHasCapability(uint8 role, bytes4 functionSig) external view returns (bool) {
        return _roleHasCapability(role, functionSig);
    }
}
