// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

interface IFacetRegistryBase {
    /// @notice Reverts when facet is already registered.
    error FacetRegistry_FacetAlreadyRegistered();

    /// @notice Reverts when facet address is zero.
    error FacetRegistry_FacetAddressZero();

    /// @notice Reverts when facet does not have any selectors.
    error FacetRegistry_FacetMustHaveSelectors();

    /// @notice Reverts when facet is not a contract.
    error FacetRegistry_FacetNotContract();

    /// @notice Reverts when facet is not registered.
    error FacetRegistry_FacetNotRegistered();

    /**
     * @notice Emitted when a facet is registered.
     * @param facet Address of the registered facet.
     * @param selectors Function selectors of the registered facet.
     */
    event FacetRegistered(address indexed facet, bytes4[] selectors);

    /**
     * @notice Emitted when a facet is unregistered.
     * @param facet Address of the unregistered facet.
     */
    event FacetUnregistered(address indexed facet);
}
