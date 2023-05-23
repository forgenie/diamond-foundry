// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

/**
 * @title IFacetRegistry
 * @notice Interface of the FacetRegistry contract.
 */
interface IFacetRegistry {
    /**
     * @notice FacetInfo struct containing address, selectors, and initializer.
     * @param addr The address of the facet.
     * @param selectors The function selectors of the facet.
     * @param initializer The selector of the initializer function, 0x0 if stateless.
     */
    struct FacetInfo {
        address addr;
        bytes4 initializer;
        bytes4[] selectors;
    }

    /**
     * @notice Emitted when a facet is registered or removed.
     * @param facetId The id of the facet.
     * @param facet The address of the facet. Zero on remove.
     */
    event FacetImplementationSet(bytes32 indexed facetId, address indexed facet);

    /**
     * @notice Registers a new facet.
     * @param facetInfo FacetInfo struct containing facet address, selectors, and initializer.
     */
    function registerFacet(FacetInfo calldata facetInfo) external;

    /**
     * @notice Removes a facet from the registry.
     * @param facetId The id of the facet.
     */
    function removeFacet(bytes32 facetId) external;

    /**
     * @notice Returns the facetId of a given facet address.
     * @param facet Address of the facet.
     * @return facetId The id of the facet.
     */
    function computeFacetId(address facet) external view returns (bytes32 facetId);

    /**
     * @notice Returns the address of a given facetId.
     * @param facetId The id of the facet.
     * @return facet The address of the facet.
     */
    function facetAddress(bytes32 facetId) external view returns (address facet);

    /**
     * @notice Returns the initializer function selector of a given facetId.
     * @param facetId The facetId of the facet.
     */
    function initializer(bytes32 facetId) external view returns (bytes4 selector);

    /**
     * @notice Returns the interfaceId of a given facet.
     * @param facetId The id of the facet.
     * @return interfaceId
     */
    function facetInterface(bytes32 facetId) external view returns (bytes4 interfaceId);

    /**
     * @notice Returns the selectors of a given facet.
     * @param facetId The id of the facet.
     * @return selectors The selectors of the facet.
     */
    function facetSelectors(bytes32 facetId) external view returns (bytes4[] memory selectors);
}
