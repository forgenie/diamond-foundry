// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

/**
 * @title IERC165
 * @notice Interface of the ERC165 standard. See [EIP-165](https://eips.ethereum.org/EIPS/eip-165).
 */
interface IERC165 {
    /**
     * @notice Returns true if this contract implements the interface
     * @param interfaceId The 4 bytes interface identifier, as specified in ERC-165
     * @dev Has to be manually set by a facet at initialization.
     * IDEA: Handle introspection automatically by XOR-ing selectors.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
