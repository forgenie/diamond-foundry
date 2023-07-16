// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { Facet } from "src/facets/Facet.sol";
import { INFTOwned } from "./INFTOwned.sol";
import { NFTOwnedBase } from "./NFTOwnedBase.sol";

contract NFTOwnedFacet is INFTOwned, NFTOwnedBase, Facet {
    function NFTOwned_init(address nftContract, uint256 tokenId) external onlyInitializing {
        __NFTOwned_init(nftContract, tokenId);
        _addInterface(type(INFTOwned).interfaceId);
    }

    /// @inheritdoc INFTOwned
    function token() external view override returns (address nftContract, uint256 tokenId) {
        return _token();
    }

    /// @inheritdoc INFTOwned
    function owner() external view override returns (address) {
        return _owner();
    }
}
