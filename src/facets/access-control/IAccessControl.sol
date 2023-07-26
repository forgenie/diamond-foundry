// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IAccessControlBase {
    /// @notice Thrown when removing admin role access from acl functions.
    error AccessControl_CannotRemoveAdmin();

    /// @notice Thrown when a user is not authorized to call a function.
    error AccessControl_CallerIsNotAuthorized();

    /**
     * @notice Emitted when a user role is updated.
     * @param user The user whose role is updated.
     * @param role The role that is updated.
     * @param enabled Whether the role is enabled.
     */
    event UserRoleUpdated(address indexed user, uint8 indexed role, bool enabled);

    /**
     * @notice Emitted when a function access of a given role is changed.
     * @param functionSig The function signature for which access has changed.
     * @param role The role having access to the function.
     * @param enabled Whether the role has access to the function.
     */
    event FunctionAccessChanged(bytes4 indexed functionSig, uint8 indexed role, bool enabled);
}

interface IAccessControl {
    /**
     * @notice Sets the function access for a given role.
     * @param functionSig The function signature to set access for.
     * @param role The role to set access for.
     * @param enabled Whether the role should be able to call the function.
     */
    function setFunctionAccess(bytes4 functionSig, uint8 role, bool enabled) external;

    /**
     * @notice Sets the role for a given user.
     * @param user The user to set the role for.
     * @param role The role to set.
     * @param enabled Whether the user should have the role.
     */
    function setUserRole(address user, uint8 role, bool enabled) external;

    /**
     * @notice Checks whether a given user can call a given function.
     * @param user The user to check.
     * @param functionSig The function signature to check.
     * @return Whether the user can call the function.
     */
    function canCall(address user, bytes4 functionSig) external view returns (bool);

    /**
     * @notice Gets the roles for a given user.
     * @param user The user to get the roles for.
     * @return The roles the user has encoded in 256 bits.
     */
    function userRoles(address user) external view returns (bytes32);

    /**
     * @notice Gets the roles that can call a given function.
     * @param functionSig The function signature to get the roles for.
     * @return The roles that can call the function encoded in 256 bits.
     */
    function functionRoles(bytes4 functionSig) external view returns (bytes32);

    /**
     * @notice Checks whether a given user has a given role.
     * @param user The user to check.
     * @param role The role to check.
     * @return Whether the user has the role.
     */
    function hasRole(address user, uint8 role) external view returns (bool);

    /**
     * @notice Checks whether a given role can call a given function.
     * @param role The role to check.
     * @param functionSig The function signature to check.
     * @return Whether the role can call the function.
     */
    function roleHasAccess(uint8 role, bytes4 functionSig) external view returns (bool);
}
