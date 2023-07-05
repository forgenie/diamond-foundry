// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

library NFTOwnedStorage {
    bytes32 internal constant NFT_OWNED_STORAGE_SLOT = keccak256("nft.owned.storage");

    struct Layout {
        address nftContract;
        uint256 tokenId;
    }

    function layout() internal pure returns (Layout storage l) {
        bytes32 position = NFT_OWNED_STORAGE_SLOT;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            l.slot := position
        }
    }
}
