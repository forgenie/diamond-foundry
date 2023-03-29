// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Diamond } from "src/Diamond.sol";

/**
 * @title IDiamondFactory
 * @notice Interface of the Diamond Factory contract.
 */
interface IDiamondFactory {
    /**
     * @notice Emitted when a diamond is deployed via the factory.
     */
    event DiamondCreated(address indexed diamond, address indexed owner);

    /**
     * @notice Creates a diamond with the given base Facets
     * @param baseFacetIds The facetIds of the base facets to be added to the diamond.
     * @return diamondAddr The address of the diamond.
     */
    function createDiamond(bytes32[] calldata baseFacetIds) external returns (address diamondAddr);

    /**
     * @notice Creates a diamond with the given base Facets and salt.
     * @param baseFacetIds The facetIds of the base facets to be added to the diamond.
     * @param salt The salt to be used in the diamond address computation.
     * @return diamondAddr The address of the diamond.
     */
    function createDiamond(bytes32[] calldata baseFacetIds, uint256 salt) external returns (address diamondAddr);

    /**
     * @notice Returns the diamond initialization parameters.
     * @return params The param struct used to initialize the diamond.
     */
    function parameters() external view returns (Diamond.InitParams memory params);

    /**
     * @notice Returns the address of the `FacetRegistry`.
     */
    function facetRegistry() external view returns (address);
}
