// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Initializable } from "src/utils/Initializable.sol";
import { IntrospectionBehavior } from "./IntrospectionBehavior.sol";
import { IERC165, IIntrospectionEvents } from "./IERC165.sol";

abstract contract IntrospectionBase is IIntrospectionEvents, Initializable {
    function __Introspection_init() internal onlyInitializing {
        _addInterface(type(IERC165).interfaceId);
    }

    function _addInterface(bytes4 interfaceId) internal {
        IntrospectionBehavior.addInterface(interfaceId);

        emit InterfaceAdded(interfaceId);
    }

    function _removeInterface(bytes4 interfaceId) internal {
        IntrospectionBehavior.removeInterface(interfaceId);

        emit InterfaceRemoved(interfaceId);
    }

    function _supportsInterface(bytes4 interfaceId) internal view returns (bool) {
        return IntrospectionBehavior.supportsInterface(interfaceId);
    }
}
