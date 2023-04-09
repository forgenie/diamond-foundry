// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

library DiamondBaseStorage {
    bytes32 internal constant DIAMOND_BASE_STORAGE_POSITION = keccak256("diamond.base.storage");

    struct Layout {
        address diamondFactory;
        mapping(bytes4 selector => bool isImmutable) immutableFunctions;
    }

    function layout() internal pure returns (Layout storage l) {
        bytes32 position = DIAMOND_BASE_STORAGE_POSITION;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            l.slot := position
        }
    }
}
