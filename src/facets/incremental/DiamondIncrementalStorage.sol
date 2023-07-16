// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

library DiamondIncrementalStorage {
    bytes32 internal constant DIAMOND_INCREMENTAL_STORAGE_POSITION = keccak256("diamond.incremental.storage");

    struct Layout {
        mapping(bytes4 selector => bool isImmutable) immutableFunctions;
    }
    // todo: add immutable facets

    function layout() internal pure returns (Layout storage l) {
        bytes32 position = DIAMOND_INCREMENTAL_STORAGE_POSITION;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            l.slot := position
        }
    }
}
