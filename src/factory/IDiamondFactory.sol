// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamond } from "src/IDiamond.sol";
import { IFacetRegistry } from "src/registry/IFacetRegistry.sol";

interface IDiamondFactoryStructs {
    /**
     * @notice Contains the information for a base facet.
     * @dev Initializer is fetched from registry.
     * @param facetId The Id of the base facet.
     * @param initCalldata The calldata containing args for the initializer.
     */
    struct BaseFacet {
        bytes32 facetId;
        bytes initArgs;
    }

    /**
     * @notice Represents data used in multiDelegateCall.
     * @dev Initializer is fetched from registry.
     */
    struct FacetInit {
        address facet;
        bytes data; // encoded initializer + args
    }
}

/**
 * @title IDiamondFactory
 * @notice Interface of the Diamond Factory contract.
 */
interface IDiamondFactory is IDiamondFactoryStructs {
    /**
     * @notice Emitted when a diamond is deployed via the factory.
     */
    event DiamondCreated(address indexed diamond, address indexed deployer, BaseFacet[] baseFacets);

    /**
     * @notice Creates a diamond with the given base Facets
     * @param baseFacets The base facets info which will be added to the diamond.
     * @return diamond The address of the diamond.
     */
    function createDiamond(BaseFacet[] calldata baseFacets) external returns (address diamond);

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
