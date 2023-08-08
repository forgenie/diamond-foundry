// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { EnumerableMap } from "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";
import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

library ERC721Storage {
    bytes32 internal constant _ERC721_STORAGE_SLOT = keccak256("erc721.storage");

    struct Layout {
        EnumerableMap.UintToAddressMap tokenOwners;
        mapping(address owner => EnumerableSet.UintSet tokenIds) ownedTokens;
        mapping(uint256 tokenId => address spender) tokenApprovals;
        mapping(address owner => mapping(address soender => bool approved)) operatorApprovals;
        string name;
        string symbol;
        string baseURI;
    }

    function layout() internal pure returns (Layout storage l) {
        bytes32 position = _ERC721_STORAGE_SLOT;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            l.slot := position
        }
    }
}
