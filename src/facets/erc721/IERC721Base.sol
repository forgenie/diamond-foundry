// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

interface IERC721Base {
    /// @notice Reverts when querying an non-existing token.
    error ERC721_QueryOfNonexistentToken();

    /// @notice Reverts when approving the current owner.
    error ERC721_ApprovalToCurrentOwner();

    /// @notice Reverts when trying to call approve but sender is not owner nor approved.
    error ERC721_OperatorNotApproved();

    /// @notice Reverts when minting a token to the zero address.
    error ERC721_MintToZeroAddress();

    /// @notice Reverts when minting a token that already exists.
    error ERC721_TokenAlreadyMinted(uint256 tokenId);

    /// @notice Reverts when receiver is a contract but does not implement `onERC721Received`.
    error ERC721_ReceiverContractError();

    /// @notice Reverts when transfer is not approved.
    error ERC721_TransferNotApproved();

    /// @notice Reverts when transferring a token to the zero address.
    error ERC721_TransferToZeroAddress();

    /// @notice Thrown when 'from' is not the current owner.
    error ERC721_InvalidOwner();

    /**
     * @notice This emits when ownership of any NFT changes by any mechanism.
     *  This event emits when NFTs are created (`from` == 0) and destroyed
     *  (`to` == 0). Exception: during contract creation, any number of NFTs
     *  may be created and assigned without emitting Transfer. At the time of
     *  any transfer, the approved address for that NFT (if any) is reset to none.
     */
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    /**
     * @notice This emits when the approved address for an NFT is changed or
     * reaffirmed. The zero address indicates there is no approved address.
     */
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    /**
     * @notice This emits when an operator is enabled or disabled for an owner.
     *  The operator can manage all NFTs of the owner.
     */
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
}
