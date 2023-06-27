// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { INFTOwned } from "./INFTOwned.sol";
import { NFTOwnedBase } from "./NFTOwnedBase.sol";

contract NFTOwnedFacet is INFTOwned, NFTOwnedBase {
    /// @inheritdoc INFTOwned
    function token() external view override returns (address nftContract, uint256 tokenId) {
        return _token();
    }

    /// @inheritdoc INFTOwned
    function owner() external view override returns (address) {
        return _owner();
    }
}
