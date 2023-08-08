// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { EnumerableMap } from "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";
import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { IERC721Receiver } from "src/facets/erc721-receiver/IERC721Receiver.sol";
import { ERC721Storage } from "./ERC721Storage.sol";
import { IERC721Base } from "./IERC721Base.sol";

abstract contract ERC721Base is IERC721Base {
    using Address for address;
    using Strings for uint256;
    using EnumerableMap for EnumerableMap.UintToAddressMap;
    using EnumerableSet for EnumerableSet.UintSet;

    function __ERC721_init(string memory name, string memory symbol, string memory baseURI) internal {
        ERC721Storage.layout().name = name;
        ERC721Storage.layout().symbol = symbol;
        ERC721Storage.layout().baseURI = baseURI;
    }

    function _name() internal view virtual returns (string memory) {
        return ERC721Storage.layout().name;
    }

    function _symbol() internal view virtual returns (string memory) {
        return ERC721Storage.layout().symbol;
    }

    function _tokenURI(uint256 tokenId) internal view virtual returns (string memory) {
        if (!_exists(tokenId)) revert ERC721_QueryOfNonexistentToken();

        string memory baseURI = ERC721Storage.layout().baseURI;
        return bytes(baseURI).length > 0 ? string.concat(baseURI, tokenId.toString()) : "";
    }

    function _balanceOf(address account) internal view returns (uint256) {
        return ERC721Storage.layout().ownedTokens[account].length();
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return ERC721Storage.layout().tokenOwners.contains(tokenId);
    }

    function _ownerOf(uint256 tokenId) internal view returns (address) {
        (bool success, address owner) = ERC721Storage.layout().tokenOwners.tryGet(tokenId);
        if (!success) revert ERC721_QueryOfNonexistentToken();
        return owner;
    }

    function _getApproved(uint256 tokenId) internal view returns (address) {
        if (!_exists(tokenId)) revert ERC721_QueryOfNonexistentToken();
        return ERC721Storage.layout().tokenApprovals[tokenId];
    }

    function _isApprovedForAll(address owner, address operator) internal view returns (bool) {
        return ERC721Storage.layout().operatorApprovals[owner][operator];
    }

    function _approve(address to, uint256 tokenId) internal {
        address owner = _ownerOf(tokenId);
        if (to == owner) revert ERC721_ApprovalToCurrentOwner();
        if (msg.sender != owner && !_isApprovedForAll(owner, msg.sender)) revert ERC721_OperatorNotApproved();

        ERC721Storage.layout().tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function _setApprovalForAll(address operator, bool approved) internal {
        if (operator == msg.sender) revert ERC721_ApprovalToCurrentOwner();
        ERC721Storage.layout().operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function _isApprovedOrOwner(
        address spender,
        uint256 tokenId
    )
        internal
        view
        returns (bool approved, address owner)
    {
        if (!_exists(tokenId)) revert ERC721_QueryOfNonexistentToken();
        owner = _ownerOf(tokenId);
        approved = (spender == owner || _getApproved(tokenId) == spender || _isApprovedForAll(owner, spender));
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        if (to == address(0)) revert ERC721_MintToZeroAddress();
        if (_exists(tokenId)) revert ERC721_TokenAlreadyMinted(tokenId);

        ERC721Storage.layout().tokenOwners.set(tokenId, to);
        ERC721Storage.layout().ownedTokens[to].add(tokenId);

        emit Transfer(address(0), to, tokenId);
    }

    function _safeMint(address to, uint256 tokenId, bytes memory data) internal virtual {
        _mint(to, tokenId);
        if (!_checkERC721Receiver(msg.sender, to, tokenId, data)) {
            revert ERC721_ReceiverContractError();
        }
    }

    function _burn(uint256 tokenId) internal virtual {
        address owner = _ownerOf(tokenId);

        ERC721Storage.layout().tokenOwners.remove(tokenId);
        ERC721Storage.layout().ownedTokens[owner].remove(tokenId);
        delete ERC721Storage.layout().tokenApprovals[tokenId];

        emit Approval(owner, address(0), tokenId);
        emit Transfer(owner, address(0), tokenId);
    }

    function _transferFrom(address from, address to, uint256 tokenId) internal virtual {
        (bool approved, address owner) = _isApprovedOrOwner(msg.sender, tokenId);
        if (!approved) revert ERC721_TransferNotApproved();
        if (to == address(0)) revert ERC721_TransferToZeroAddress();
        if (from != owner) revert ERC721_InvalidOwner();

        ERC721Storage.layout().tokenOwners.set(tokenId, to);
        ERC721Storage.layout().ownedTokens[from].remove(tokenId);
        ERC721Storage.layout().ownedTokens[to].add(tokenId);
        delete ERC721Storage.layout().tokenApprovals[tokenId];

        emit Approval(owner, address(0), tokenId);
        emit Transfer(owner, to, tokenId);
    }

    function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) internal virtual {
        _transferFrom(from, to, tokenId);
        if (!_checkERC721Receiver(from, to, tokenId, data)) {
            revert ERC721_ReceiverContractError();
        }
    }

    function _checkERC721Receiver(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    )
        internal
        returns (bool success)
    {
        if (!to.isContract()) return true;

        try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) returns (bytes4 response) {
            return response == IERC721Receiver.onERC721Received.selector;
        } catch Error(string memory reason) {
            if (bytes(reason).length == 0) revert ERC721_ReceiverContractError();
            require(false, reason);
        }
    }
}
