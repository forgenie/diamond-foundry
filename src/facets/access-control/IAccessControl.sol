// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IAccessControlEvents {
    event UserRoleUpdated(address indexed user, uint8 indexed role, bool enabled);

    event RoleCapabilityUpdated(uint8 indexed role, bytes4 indexed functionSig, bool enabled)
    
}

interface IAccessControl {
    function setRoleCapability(uint8 role, bytes4 functionSig, bool enabled) external;

    function setUserRole(address user, uint8 role, bool enabled) external;

    function canCall(address user, bytes4 functionSig) external view returns (bool);

    function userRoles(address user) external view returns (bytes32);

    function allowedRoles(bytes4 functionSig) external view returns (bytes32);

    function hasRole(address user, uint8 role) external view returns (bool);

    function roleHasCapability(uint8 role, bytes4 functionSig) external view returns (bool);
}
