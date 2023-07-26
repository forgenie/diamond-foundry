// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { Facet } from "src/facets/Facet.sol";
import { AccessControlBase } from "./AccessControlBase.sol";
import { IAccessControl } from "./IAccessControl.sol";
import { DEFAULT_ADMIN_ROLE } from "src/Constants.sol";

contract AccessControlFacet is IAccessControl, AccessControlBase, Facet {
    function AccessControl_init(address roleAdmin) external onlyInitializing {
        _setUserRole(roleAdmin, DEFAULT_ADMIN_ROLE, true);
        _setFunctionAccess(this.setFunctionAccess.selector, DEFAULT_ADMIN_ROLE, true);
        _setFunctionAccess(this.setUserRole.selector, DEFAULT_ADMIN_ROLE, true);

        _addInterface(type(IAccessControl).interfaceId);
    }

    /// @inheritdoc IAccessControl
    function setFunctionAccess(bytes4 functionSig, uint8 role, bool enabled) external onlyAuthorized {
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
