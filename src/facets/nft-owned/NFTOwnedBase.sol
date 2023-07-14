// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { INFTOwned } from "./INFTOwned.sol";
import { NFTOwnedBehavior } from "./NFTOwnedBehavior.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";

abstract contract NFTOwnedBase {
    function __NFTOwned_init(address nftContract, uint256 tokenId) internal {
        NFTOwnedBehavior.setToken(nftContract, tokenId);
        IntrospectionBehavior.addInterface(type(INFTOwned).interfaceId);
    }

    function _token() internal view virtual returns (address nftContract, uint256 tokenId) {
        (nftContract, tokenId) = NFTOwnedBehavior.token();
    }

    function _owner() internal view virtual returns (address) {
        return NFTOwnedBehavior.owner();
    }
}
