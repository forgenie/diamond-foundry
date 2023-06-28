// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { NFTOwnedStorage } from "./NFTOwnedStorage.sol";

error NFTOwned_CallerIsNotOwner();

library NFTOwnedBehavior {
    function checkOwner() internal view {
        if (owner() != msg.sender) {
            revert NFTOwned_CallerIsNotOwner();
        }
    }

    function setToken(address nftContract, uint256 tokenId) internal {
        NFTOwnedStorage.Layout storage l = NFTOwnedStorage.layout();
        l.nftContract = nftContract;
        l.tokenId = tokenId;
    }

    function token() internal view returns (address nftContract, uint256 tokenId) {
        NFTOwnedStorage.Layout storage l = NFTOwnedStorage.layout();
        nftContract = l.nftContract;
        tokenId = l.tokenId;
    }

    function owner() internal view returns (address) {
        NFTOwnedStorage.Layout storage l = NFTOwnedStorage.layout();
        return IERC721(l.nftContract).ownerOf(l.tokenId);
    }
}
