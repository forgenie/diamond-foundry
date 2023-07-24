// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

/**
 * @title IFacetRegistry
 * @notice Interface of the FacetRegistry contract.
 */
interface IFacetRegistry {
    /**
     * @notice Registers a new facet.
     * @param facet Address of the facet to add.
     * @param selectors Function selectors of the facet.
     */
    function addFacet(address facet, bytes4[] calldata selectors) external;

    /**
     * @notice Removes a facet from the registry.
     * @param facet Address of the facet to remove.
     */
    function removeFacet(address facet) external;

    /**
     * @notice Deploys a new facet and registers it.
     * @param salt Salt used to create the address of the new facet.
     * @param creationCode Creation code of the new facet.
     * @param selectors Function selectors of the new facet.
     * @return facet Address of the new facet.
     */
    function deployFacet(
        bytes32 salt,
        bytes calldata creationCode,
        bytes4[] calldata selectors
    )
        external
        returns (address facet);

    /**
     * @notice Computes the address of a facet deployed with the given salt and creation code.
     * @param salt Salt used to create the address of the new facet.
     * @param creationCode Creation code of the new facet.
     */
    function computeFacetAddress(bytes32 salt, bytes calldata creationCode) external view returns (address facet);

    /**
     * @notice Returns the selectors of a registered facet.
     * @param facet The address of the facet.
     * @return selectors The selectors of the facet.
     */
    function facetSelectors(address facet) external view returns (bytes4[] memory selectors);

    /**
     * @notice Returns the addresses of all registered facets.
     * @return facets The addresses of all registered facets.
     */
    function facetAddresses() external view returns (address[] memory facets);
}
