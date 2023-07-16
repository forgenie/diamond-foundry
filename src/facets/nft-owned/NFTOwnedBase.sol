// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { INFTOwned } from "./INFTOwned.sol";
import { NFTOwnedStorage } from "./NFTOwnedStorage.sol";

abstract contract NFTOwnedBase {
    function __NFTOwned_init(address nftContract, uint256 tokenId) internal {
        NFTOwnedStorage.layout().nftContract = nftContract;
        NFTOwnedStorage.layout().tokenId = tokenId;
    }

    function _token() internal view virtual returns (address nftContract, uint256 tokenId) {
        nftContract = NFTOwnedStorage.layout().nftContract;
        tokenId = NFTOwnedStorage.layout().tokenId;
    }

    function _owner() internal view virtual returns (address) {
        uint256 tokenId = NFTOwnedStorage.layout().tokenId;
        return IERC721(NFTOwnedStorage.layout().nftContract).ownerOf(tokenId);
    }
}
