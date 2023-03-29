// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

// implements interface
import { IERC165 } from "./IERC165.sol";

// uses storage
import { IntrospectionStorage } from "./IntrospectionStorage.sol";

error Introspection_addInteface_AlreadySupported();
error Introspection_removeInterface_AlreadyNotSupported();

library IntrospectionBehavior {
    function supportsInterface(bytes4 interfaceId) internal view returns (bool) {
        return IntrospectionStorage.layout().supportedInterfaces[interfaceId];
    }

    function addInterface(bytes4 interfaceId) internal {
        if (!supportsInterface(interfaceId)) {
            IntrospectionStorage.layout().supportedInterfaces[interfaceId] = true;
        } else {
            revert Introspection_addInteface_AlreadySupported();
        }
    }

    function removeInterface(bytes4 interfaceId) internal {
        if (supportsInterface(interfaceId)) {
            IntrospectionStorage.layout().supportedInterfaces[interfaceId] = false;
        } else {
            revert Introspection_removeInterface_AlreadyNotSupported();
        }
    }
}
