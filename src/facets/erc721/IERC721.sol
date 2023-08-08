// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

interface IERC721Metadata {
    /**
     * @notice Query the name of the NFT collection.
     * @return name The name of the NFT collection.
     */
    function name() external view returns (string memory);

    /**
     * @notice Query the symbol of the NFT collection.
     * @return symbol The symbol of the NFT collection.
     */
    function symbol() external view returns (string memory);

    /**
     * @notice Query the Uniform Resource Identifier (URI) for `tokenId` token.
     * @param tokenId The token ID to query.
     * @return uri The URI string for the specified token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

/**
 * @title ERC721 Interface
 * @notice This interface follows the ERC-721 standard for non-fungible tokens on the Ethereum blockchain. For more
 * details, refer to https://eips.ethereum.org/EIPS/eip-721.
 */
interface IERC721 is IERC721Metadata {
    /**
     * @notice Safely transfer a token from one address to another, checking for ERC721Receiver implementation.
     * @param from The address sending the token.
     * @param to The address receiving the token.
     * @param tokenId The ID of the token to be transferred.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @notice Safely transfer a token from one address to another with additional data, checking for ERC721Receiver.
     * @param from The address sending the token.
     * @param to The address receiving the token.
     * @param tokenId The ID of the token to be transferred.
     * @param data Additional data payload.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    /**
     * @notice Transfer a token from one address to another, without checking for ERC721Receiver implementation.
     * @param from The address sending the token.
     * @param to The address receiving the token.
     * @param tokenId The ID of the token to be transferred.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @notice Grant approval to a given account to spend a specific token.
     * @param operator The address to be approved.
     * @param tokenId The token to approve.
     */
    function approve(address operator, uint256 tokenId) external;

    /**
     * @notice Grant approval to or revoke approval from a given account to spend all tokens held by the sender.
     * @param operator The address to be approved or revoked.
     * @param status The approval status (true for approved, false for revoked).
     */
    function setApprovalForAll(address operator, bool status) external;

    /**
     * @notice Get the approval status for a given token.
     * @param tokenId The token ID to query.
     * @return operator The address approved to spend the token.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @notice Query the approval status of a given operator with respect to a given address.
     * @param account The address to query for approval granted.
     * @param operator The address to query for approval received.
     * @return status The status indicating whether the operator is approved to spend tokens held by the account.
     */
    function isApprovedForAll(address account, address operator) external view returns (bool status);

    /**
     * @notice Query the balance of tokens held by the given address.
     * @param account Address for which the token balance is queried.
     * @return balance The quantity of tokens held by the address.
     */
    function balanceOf(address account) external view returns (uint256 balance);

    /**
     * @notice Query the owner of the given token.
     * @param tokenId The token ID to query.
     * @return owner The address of the token owner.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);
}
