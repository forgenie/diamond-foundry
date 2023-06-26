// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { SelfReferenced } from "./SelfReferenced.sol";

error Initializable_AlreadyInitialized(uint8 version);
error Initializable_NotInInitializingState();
error Initializable_InInitializingState();

abstract contract Initializable {
    bytes32 internal constant _INITIALIZABLE_SLOT = keccak256("utils.initializable");

    struct Storage {
        uint8 initialized;
        bool initializing;
    }

    event Initialized(uint8 version);

    modifier initializer() {
        Storage storage s = layout();

        bool isTopLevelCall = !s.initializing;
        if ((!isTopLevelCall || s.initialized >= 1) && (Address.isContract(address(this)) || s.initialized != 1)) {
            revert Initializable_AlreadyInitialized(s.initialized);
        }
        s.initialized = 1;
        if (isTopLevelCall) {
            s.initializing = true;
        }
        _;
        if (isTopLevelCall) {
            s.initializing = false;
            emit Initialized(1);
        }
    }

    modifier reinitializer(uint8 version) {
        Storage storage s = layout();

        if (s.initializing || s.initialized >= version) {
            revert Initializable_AlreadyInitialized(s.initialized);
        }
        s.initialized = version;
        s.initializing = true;
        _;
        s.initializing = false;
        emit Initialized(version);
    }

    modifier onlyInitializing() {
        if (!layout().initializing) revert Initializable_NotInInitializingState();
        _;
    }

    function _disableInitializers() internal {
        Storage storage s = layout();
        if (s.initializing) revert Initializable_InInitializingState();

        if (s.initialized < type(uint8).max) {
            s.initialized = type(uint8).max;
            emit Initialized(type(uint8).max);
        }
    }

    function layout() private pure returns (Storage storage s) {
        bytes32 position = _INITIALIZABLE_SLOT;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            s.slot := position
        }
    }
}
