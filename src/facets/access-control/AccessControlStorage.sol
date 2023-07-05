// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

library AccessControlStorage {
    bytes32 internal constant STORAGE_SLOT = keccak256("diamond.standard.access-control.storage");

    struct Layout {
        mapping(address user => bytes32 roles) userRoles;
        mapping(bytes4 method => bytes32 roles) allowedRoles;
    }

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
