// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

interface IERC721Receiver {
    /**
     * @notice The ERC721 smart contract calls this function on the recipient
     *  after a `transfer`. This function MAY throw to revert and reject the
     *  transfer. Return of other than the magic value MUST result in the
     *  transaction being reverted.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes memory data
    )
        external
        returns (bytes4);
}
