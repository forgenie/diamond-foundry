// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

/**
 * @title IERC173
 * @notice Interface of the ERC173 contract. See [EIP-173](https://eips.ethereum.org/EIPS/eip-173).
 */
interface IERC173 {
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @notice Returns the owner of the contract.
     */
    function owner() external view returns (address);

    /**
     * @notice Transfers the ownership of the contract to a new account (`newOwner`).
     * @dev OwnershipTransferred event is emitted here.
     */
    function transferOwnership(address newOwner) external;
}
