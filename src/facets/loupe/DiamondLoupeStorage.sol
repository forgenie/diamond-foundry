// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

library DiamondLoupeStorage {
    bytes32 internal constant DIAMOND_LOUPE_STORAGE = keccak256("diamond.loupe.storage");

    struct Storage {
        mapping(bytes4 interfaceId => bool isSupported) supportedInterfaces;
    }

    function layout() internal pure returns (Storage storage l) {
        bytes32 position = DIAMOND_LOUPE_STORAGE;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            l.slot := position
        }
    }
}
