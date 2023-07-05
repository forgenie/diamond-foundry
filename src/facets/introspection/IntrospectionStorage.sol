// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

library IntrospectionStorage {
    bytes32 internal constant INTROSPECTION_STORAGE_POSITION = keccak256("introspection.storage");

    struct Storage {
        mapping(bytes4 interfaceId => bool isSupported) supportedInterfaces;
    }

    function layout() internal pure returns (Storage storage l) {
        bytes32 position = INTROSPECTION_STORAGE_POSITION;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            l.slot := position
        }
    }
}
