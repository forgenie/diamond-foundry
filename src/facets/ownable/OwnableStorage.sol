// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

library OwnableStorage {
    struct Layout {
        address owner;
    }

    bytes32 internal constant OWNABLE_STORAGE_SLOT = keccak256("diamond.ownable.storage");

    function layout() internal pure returns (Layout storage l) {
        bytes32 position = OWNABLE_STORAGE_SLOT;

        assembly {
            l.slot := position
        }
    }
}
