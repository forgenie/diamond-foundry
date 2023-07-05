// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

library OwnableStorage {
    bytes32 internal constant OWNABLE_STORAGE_SLOT = keccak256("ownable.storage");

    struct Layout {
        address owner;
    }

    function layout() internal pure returns (Layout storage l) {
        bytes32 position = OWNABLE_STORAGE_SLOT;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            l.slot := position
        }
    }
}
