// SPDX-License-Identifier MIT License
pragma solidity 0.8.19;

interface IOwnable2Step {
    /**
     * @notice Emitted when ownership transfer is started.
     * @dev Finalized with {acceptOwnership}.
     */
    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);

    /**
     * @notice Starts the ownership transfer to a new account.
     * @param newOwner The address of the new owner.
     * @dev Also defined in IERC173.
     */
    function transferOwnership(address newOwner) external;

    /**
     * @notice Returns the address of the pending owner, if there is one.
     * @return address of the pending owner.
     */
    function pendingOwner() external view returns (address);

    /**
     * @notice The new owner accepts the ownership transfer.
     */
    function acceptOwnership() external;
}
