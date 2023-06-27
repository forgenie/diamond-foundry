// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { NFTOwnedBehavior } from "./NFTOwnedBehavior.sol";

abstract contract NFTOwnedBase {
    modifier onlyOwner() {
        NFTOwnedBehavior.checkOwner();
        _;
    }

    function __NFTOwned_init(address nftContract, uint256 tokenId) internal {
        NFTOwnedBehavior.setToken(nftContract, tokenId);
    }

    function _token() internal view virtual returns (address nftContract, uint256 tokenId) {
        return NFTOwnedBehavior.token();
    }

    function _owner() internal view virtual returns (address) {
        return NFTOwnedBehavior.owner();
    }
}
