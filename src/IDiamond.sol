// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

interface IDiamond {
    /// @dev Expresses the action of adding, replacing, or removing a facet.
    enum FacetCutAction {
        Add, // 0
        Replace, // 1
        Remove // 2
    }

    /// @dev Describes a facet to be added, replaced or removed.
    /// @param facetAddress Address of the facet, that contains the functions to be cut.
    /// @param action The action to be performed.
    /// @param functionSelectors The selectors of the functions to be cut.
    struct FacetCut {
        address facet;
        FacetCutAction action;
        bytes4[] selectors;
    }

    /// @dev Emitted when a facet is added, replaced or removed.
    /// @param facetCuts The Facet actions that were performed.
    /// @param init The address where the initialization was delegated to.
    /// @param initData The data that was passed to the initialization function.
    event DiamondCut(FacetCut[] facetCuts, address init, bytes initData);
}
