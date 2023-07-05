// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

interface INFTOwned {
    /**
     * @notice Returns the ERC721 contract and token ID representing the ownership of this contract.
     * @param nftContract The ERC721 contract address.
     * @param tokenId The token ID.
     */
    function token() external view returns (address nftContract, uint256 tokenId);

    /**
     * @notice Returns the current owner of the NFT.
     */
    function owner() external view returns (address);
}
