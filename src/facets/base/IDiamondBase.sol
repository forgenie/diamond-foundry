// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

error Diamond__ImplementationIsNotContract();

/**
 * @title IDiamondBase
 * @notice Interface of the Diamond Base contract.
 */
interface IDiamondBase {
    /**
     * @notice Makes the functions in the selectors array immutable.
     * @param selectors The selectors of the functions to make immutable.
     */
    function immute(bytes4[] calldata selectors) external;

    /**
     * @notice Returns true if the function selector is immutable.
     */
    function isImmutable(bytes4 selector) external view returns (bool);

    /**
     * @notice Returns the address of the diamond factory that created the diamond.
     */
    function diamondFactory() external view returns (address);

    // IDEA: Allow DiamondBase to implement the fallback function
    // fallback() external payable;
}
