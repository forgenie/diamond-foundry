// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { Facet } from "src/facets/Facet.sol";
import { AccessControlBase } from "./AccessControlBase.sol";
import { IAccessControl } from "./IAccessControl.sol";

error AccessControl_CannotRemoveAdmin();

contract AccessControlFacet is IAccessControl, AccessControlBase, Facet {
    uint8 public constant DEFAULT_ADMIN_ROLE = 0;

    function AccessControl_init(address roleAdmin) external onlyInitializing {
        _setUserRole(roleAdmin, DEFAULT_ADMIN_ROLE, true);
        _setFunctionAccess(this.setFunctionAccess.selector, DEFAULT_ADMIN_ROLE, true);
        _setFunctionAccess(this.setUserRole.selector, DEFAULT_ADMIN_ROLE, true);
    }

    /// @inheritdoc IAccessControl
    function setFunctionAccess(bytes4 functionSig, uint8 role, bool enabled) external onlyAuthorized {
        if (
            role == DEFAULT_ADMIN_ROLE && enabled == false
                && (functionSig == this.setFunctionAccess.selector || functionSig == this.setUserRole.selector)
        ) {
            revert AccessControl_CannotRemoveAdmin();
        }

        _setFunctionAccess(functionSig, role, enabled);
    }

    /// @inheritdoc IAccessControl
    function setUserRole(address user, uint8 role, bool enabled) external onlyAuthorized {
        _setUserRole(user, role, enabled);
    }

    /// @inheritdoc IAccessControl
    function canCall(address user, bytes4 functionSig) external view returns (bool) {
        return _canCall(user, functionSig);
    }

    /// @inheritdoc IAccessControl
    function userRoles(address user) external view returns (bytes32) {
        return _userRoles(user);
    }

    /// @inheritdoc IAccessControl
    function functionRoles(bytes4 functionSig) external view returns (bytes32) {
        return _functionRoles(functionSig);
    }

    /// @inheritdoc IAccessControl
    function hasRole(address user, uint8 role) external view returns (bool) {
        return _hasRole(user, role);
    }

    /// @inheritdoc IAccessControl
    function roleHasAccess(uint8 role, bytes4 functionSig) external view returns (bool) {
        return _roleHasAccess(role, functionSig);
    }
}
