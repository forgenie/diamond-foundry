// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.20;

import { IDiamond } from "src/IDiamond.sol";

interface IDiamondCutBase {
    /// @notice Thrown when the facet cut has no selectors. 
    error DiamondCut_SelectorArrayEmpty(address facet);

    /// @notice Thrown when the facet address is zero address.
    error DiamondCut_FacetIsZeroAddress();

    /// @notice Thrown when the facet address isn't a contract.
    error DiamondCut_FacetIsNotContract(address facet);

    /// @notice Thrown when the facet cut action doesn't exist.
    error DiamondCut_IncorrectFacetCutAction();

    /// @notice Thrown when a facet cut selector is zero.
    error DiamondCut_SelectorIsZero();

    /// @notice Thrown when a facet cut selector being added already exists.
    error DiamondCut_FunctionAlreadyExists(bytes4 selector);

    /// @notice Thrown when facet cut tries to remove selectors from another facet.
    error DiamondCut_CannotRemoveFromOtherFacet(address facet, bytes4 selector);

    /// @notice Thrown when diamond cut tries to replace a facet with itself.
    error DiamondCut_FunctionFromSameFacet(bytes4 selector);

    /// @notice Thrown when a diamond cut tries to replace a facet that doesn't exist.
    error DiamondCut_NonExistingFunction(bytes4 selector);

     /// @notice Thrown when the diamond cut tries to remove an immutable facet.
    error DiamondCut_ImmutableFacet();

    /// @notice Thrown when trying to send init data to an address that isn't a contract.
    error DiamondCut_InitIsNotContract(address init);

    /**
     * @dev Emitted when a facet is added, replaced or removed.
     * @param facetCuts The Facet actions that were performed.
     * @param init The address where the initialization was delegated to.
     * @param initData The data that was passed to the initialization function.
     */
    event DiamondCut(IDiamond.FacetCut[] facetCuts, address init, bytes initData);
}
