// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { IERC721, IERC721Metadata } from "./IERC721.sol";
import { ERC721Base } from "./ERC721Base.sol";
import { Facet } from "src/facets/Facet.sol";

contract ERC721Facet is IERC721, ERC721Base {
    function ERC721_init(string memory name_, string memory symbol_, string memory baseURI) external {
        __ERC721_init(name_, symbol_, baseURI);
    }

    /// @inheritdoc IERC721Metadata
    function name() external view returns (string memory) {
        return _name();
    }

    /// @inheritdoc IERC721Metadata
    function symbol() external view returns (string memory) {
        return _symbol();
    }

    /// @inheritdoc IERC721Metadata
    function tokenURI(uint256 tokenId) external view returns (string memory) {
        return _tokenURI(tokenId);
    }

    /// @inheritdoc IERC721
    function balanceOf(address account) external view returns (uint256) {
        return _balanceOf(account);
    }

    /// @inheritdoc IERC721
    function ownerOf(uint256 tokenId) external view returns (address) {
        return _ownerOf(tokenId);
    }

    /// @inheritdoc IERC721
    function getApproved(uint256 tokenId) external view returns (address) {
        return _getApproved(tokenId);
    }

    /// @inheritdoc IERC721
    function isApprovedForAll(address owner, address operator) external view returns (bool) {
        return _isApprovedForAll(owner, operator);
    }

    /// @inheritdoc IERC721
    function approve(address to, uint256 tokenId) external {
        _approve(to, tokenId);
    }

    /// @inheritdoc IERC721
    function setApprovalForAll(address operator, bool approved) external {
        _setApprovalForAll(operator, approved);
    }

    /// @inheritdoc IERC721
    function transferFrom(address from, address to, uint256 tokenId) external {
        _transferFrom(from, to, tokenId);
    }

    /// @inheritdoc IERC721
    function safeTransferFrom(address from, address to, uint256 tokenId) external {
        _safeTransferFrom(from, to, tokenId, "");
    }

    /// @inheritdoc IERC721
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) external {
        _safeTransferFrom(from, to, tokenId, data);
    }
}
