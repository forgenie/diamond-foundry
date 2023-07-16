// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

interface IDiamondIncrementalBase {
    /// @notice Thrown when a function is already immutable.
    error DiamondIncremental_AlreadyImmutable(bytes4 selector);

    /// @notice Thrown when trying to remove an immutable function.
    error DiamondIncremental_ImmutableFunction(bytes4 selector);

    /**
     * @notice Emitted when a function is made immutable.
     * @param selector The selector of the function made immutable.
     */
    event SelectorTurnedImmutable(bytes4 indexed selector);
}

/**
 * @notice Interface for the `DiamondIncremental` facet.
 *          A granular alternative to removing the `diamondCut` method.
 */
interface IDiamondIncremental is IDiamondIncrementalBase {
    /**
     * @notice Sets function as immutable.
     * @param selector The selector of the functions to make immutable.
     */
    function turnImmutable(bytes4 selector) external;

    /**
     * @notice Returns true if the function selector is immutable.
     * @param selector The selector of the function to check.
     */
    function isImmutable(bytes4 selector) external view returns (bool);
    /// todo: Make facet-level immutability possible
}
