// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamond } from "src/IDiamond.sol";
import { IFacetRegistry } from "src/registry/IFacetRegistry.sol";

struct BaseFacetInfo {
    bytes32 facetId;
    bytes initData; // contains just args for the initializer
}

struct FacetInit {
    address facet;
    bytes data; // encoded initializer + args
}

/**
 * @title IDiamondFactory
 * @notice Interface of the Diamond Factory contract.
 */
interface IDiamondFactory {
    /**
     * @notice Emitted when a diamond is deployed via the factory.
     */
    event DiamondCreated(address indexed diamond, address indexed deployer, BaseFacetInfo[] baseFacets);

    /**
     * @notice Creates a diamond with the given base Facets
     * @param baseFacets The base facets info which will be added to the diamond.
     * @return diamond The address of the diamond.
     */
    function createDiamond(BaseFacetInfo[] calldata baseFacets) external returns (address diamond);

    /**
     * @notice Creates a diamond with the given base Facets and salt.
     * @param baseFacetIds The facetIds of the base facets to be added to the diamond.
     * @param salt The salt to be used in the diamond address computation.
     * @return diamond The address of the diamond.
     */
    // TODO: function createDiamond(bytes32[] calldata baseFacetIds, uint256 salt) external returns (address diamond);

    /**
     * @notice Builds a FacetCut struct from a given facetId.
     * @param action The action to be performed.
     * @param facetId The facetId of the facet.
     */
    function makeFacetCut(
        IDiamond.FacetCutAction action,
        bytes32 facetId
    )
        external
        view
        returns (IDiamond.FacetCut memory facetCut);

    /**
     * @dev To be called only via delegatecall.
     * @notice Executes a delegatecall to initialize the diamond.
     * @param diamondInitData The FacetInit data to be used in the delegatecall.
     */
    function multiDelegateCall(FacetInit[] memory diamondInitData) external;

    /**
     * @notice Returns the address of the `FacetRegistry`.
     */
    function facetRegistry() external view returns (IFacetRegistry);
}
