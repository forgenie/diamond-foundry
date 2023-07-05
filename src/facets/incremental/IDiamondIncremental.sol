// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

interface IDiamondIncrementalEvents {
    /**
     * @notice Emitted when a function is made immutable.
     */
    event SelectorTurnedImmutable(bytes4 indexed selector);
}

/**
 * @notice Interface for the `DiamondIncremental` facet.
 *          A granular alternative to removing the `diamondCut` method.
 */
interface IDiamondIncremental is IDiamondIncrementalEvents {
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
}
