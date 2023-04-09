// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

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
     * TODO:  Allow just initializers to be registered.
     */
    struct FacetInfo {
        string name;
        address addr;
        bytes4 initializer; // selector of initializer function, 0x0 if stateless
        bytes4[] selectors;
    }

    /**
     * @notice Emitted when a facet is registered or removed.
     * @param facetId The id of the facet.
     * @param facet The address of the facet. Zero on remove.
     */
    event FacetImplementationSet(bytes32 indexed facetId, address indexed facet);

    /**
     * @notice Registers a new facet for use in the diamond.
     * @param facetInfo FacetInfo struct containing facet name, address, selectors, and initializer.
     */
    function registerFacet(FacetInfo calldata facetInfo) external;

    /**
     * @notice Removes a facet from the registry.
     * @param facetId The id of the facet.
     */
    function removeFacet(bytes32 facetId) external;

    /**
     * @notice Computes the id of the facet.
     * @param name The name of the facet. Must be CamelCase and correspond with contract name.
     * @return facetId The id of the facet.
     */
    function computeFacetId(string calldata name) external view returns (bytes32 facetId);

    /**
     * @notice Returns the address of a given facetId.
     * @param facetId The id of the facet.
     * @return facet The address of the facet.
     */
    function getFacetAddress(bytes32 facetId) external view returns (address facet);

    /**
     * @notice Returns the facetId of a given facet address.
     * @param facet Address of the facet.
     * @return facetId The facetId of the facet.
     */
    function getFacetId(address facet) external view returns (bytes32 facetId);

    /**
     * @notice Returns the initializer function selector of a given facetId.
     * @param facetId The facetId of the facet.
     * @return initializer
     */
    function getInitializer(bytes32 facetId) external view returns (bytes4 initializer);

    /**
     * @notice Returns the interfaceId of a given facet.
     * @param facetId The id of the facet.
     * @return interfaceId
     */
    function getFacetInterface(bytes32 facetId) external view returns (bytes4 interfaceId);

    /**
     * @notice Returns the selectors of a given facet.
     * @param facetId The id of the facet.
     * @return selectors The selectors of the facet.
     */
    function getFacetSelectors(bytes32 facetId) external view returns (bytes4[] memory selectors);
}
