// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

interface IOwnableBase {
    /// @notice Thrown when setting the owner to the zero address.
    error Ownable_ZeroAddress();

    /// @notice Thrown when a caller is not the owner.
    error Ownable_CallerIsNotOwner();

    /**
     * @notice Emitted when the ownership of the contract is transferred.
     * @param previousOwner The previous owner of the contract.
     * @param newOwner The new owner of the contract.
     */
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
}

/**
 * @title IERC173
 * @notice Interface of the ERC173 contract. See [EIP-173](https://eips.ethereum.org/EIPS/eip-173).
 */
interface IERC173 is IOwnableBase {
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
