// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { INFTOwned } from "./INFTOwned.sol";
import { IOwned } from "src/auth/Auth.sol";
import { NFTOwnedBehavior } from "./NFTOwnedBehavior.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";

abstract contract NFTOwnedBase {
    modifier onlyOwner() {
        NFTOwnedBehavior.checkOwner();
        _;
    }

    function __NFTOwned_init(address nftContract, uint256 tokenId) internal {
        NFTOwnedBehavior.setToken(nftContract, tokenId);
        IntrospectionBehavior.addInterface(type(IOwned).interfaceId);
        IntrospectionBehavior.addInterface(type(INFTOwned).interfaceId);
    }

    function _token() internal view virtual returns (address nftContract, uint256 tokenId) {
        (nftContract, tokenId) = NFTOwnedBehavior.token();
    }

    function _owner() internal view virtual returns (address) {
        return NFTOwnedBehavior.owner();
    }
}
