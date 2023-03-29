// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamond } from "src/IDiamond.sol";

/**
 * @title IFacetRegistry
 * @notice Interface of the Facet Registry contract.
 */
interface IFacetRegistry {
    /**
     * @notice FacetInfo struct containing facet name, address, selectors, and initializer.
     * @param name The name of the facet. Must be CamelCase and correspond with contract name.
     * @param addr The address of the facet.
     * @param selectors The function selectors of the facet.
     * @param initializer The selector of the initializer function.
     * TODO:  Allow reinitializers and migrators to be registered.
     */
    struct FacetInfo {
        string name;
        address addr;
        bytes4[] selectors; // XOR to get interfaceId
        bytes4 initializer; // selector of initializer function
    }

    /**
     * @notice Registers a new facet for use in the diamond.
     * @param facetInfo FacetInfo struct containing facet name, address, selectors, and initializer.
     */
    function registerFacet(FacetInfo calldata facetInfo) external;

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
     * @notice Returns the facetId of a given facet address.
     * @param facetAddr Address of the facet.
     * @return facetId The facetId of the facet.
     */
    function getFacetId(address facetAddr) external view returns (bytes32 facetId);

    /**
     * @notice Returns the facetId computed from the facet name.
     * @param name The name of the facet.
     * @return facetId The facetId of the facet.
     */
    function computeFacetId(string calldata name) external pure returns (bytes32 facetId);

    // TBA
    // function getInitializer(bytes32 facetId) external view returns (bytes4);
    // function getFacetInterface(bytes32 facetId) external view returns (bytes4 interfaceId);
    // function getFacetSelectors(bytes32 facetId) external view returns (bytes4[] memory selectors);
}
