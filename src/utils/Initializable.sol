// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";

abstract contract Initializable {
    error AlreadyInitialized(uint32 version);
    error NotInInitializingState();
    error InInitializingState();

    bytes32 internal constant _INITIALIZABLE_SLOT = keccak256("utils.initializable");

    struct InitializableStorage {
        uint32 version;
        bool initializing;
    }

    event Initialized(uint32 version);

    modifier initializer() {
        InitializableStorage storage s = _initializableLayout();

        bool isTopLevelCall = !s.initializing;
        if (isTopLevelCall ? s.version >= 1 : _isNotConstructor()) {
            revert AlreadyInitialized(s.version);
        }
        s.version = 1;
        if (isTopLevelCall) {
            s.initializing = true;
        }
        _;
        if (isTopLevelCall) {
            s.initializing = false;
            emit Initialized(1);
        }
    }

    modifier reinitializer(uint32 version) {
        InitializableStorage storage s = _initializableLayout();

        if (s.initializing || s.version >= version) {
            revert AlreadyInitialized(s.version);
        }
        s.version = version;
        s.initializing = true;
        _;
        s.initializing = false;
        emit Initialized(version);
    }

    modifier onlyInitializing() {
        if (!_initializableLayout().initializing) revert NotInInitializingState();
        _;
    }

    function _nextVersion() internal view returns (uint32) {
        return _initializableLayout().version + 1;
    }

    function _disableInitializers() internal {
        InitializableStorage storage s = _initializableLayout();
        if (s.initializing) revert InInitializingState();

        if (s.version < type(uint32).max) {
            s.version = type(uint32).max;
            emit Initialized(type(uint32).max);
        }
    }

    function _isNotConstructor() private view returns (bool) {
        return Address.isContract(address(this));
    }

    function _initializableLayout() private pure returns (InitializableStorage storage s) {
        bytes32 position = _INITIALIZABLE_SLOT;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            s.slot := position
        }
    }
}
