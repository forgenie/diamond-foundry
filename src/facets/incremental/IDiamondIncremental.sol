// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

/**
 * @notice Interface for the `DiamondIncremental` facet.
 *          A granular alternative to removing the `diamondCut` method.
 */
interface IDiamondIncremental {
    /**
     * @notice Sets multiple functions as immutable.
     * @param selectors The selectors of the functions to make immutable.
     */
    function immute(bytes4[] memory selectors) external;

    /**
     * @notice Returns true if the function selector is immutable.
     * @param selector The selector of the function to check.
     */
    function isImmutable(bytes4 selector) external view returns (bool);
}
