// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { IDiamond } from "src/IDiamond.sol";

interface IDiamondCutBase {
    //todo: add docs
    error DiamondCut_SelectorArrayEmpty(address facet);
    error DiamondCut_FacetIsZeroAddress();
    error DiamondCut_FacetIsNotContract(address facet);
    error DiamondCut_IncorrectFacetCutAction();
    error DiamondCut_SelectorIsZero();
    error DiamondCut_FunctionAlreadyExists(bytes4 selector);
    error DiamondCut_CannotRemoveFromOtherFacet(address facet, bytes4 selector);
    error DiamondCut_FunctionFromSameFacet(bytes4 selector);
    error DiamondCut_NonExistingFunction(bytes4 selector);
    error DiamondCut_ImmutableFacet();
    error DiamondCut_InitIsNotContract(address init);

    /**
     * @dev Emitted when a facet is added, replaced or removed.
     * @param facetCuts The Facet actions that were performed.
     * @param init The address where the initialization was delegated to.
     * @param initData The data that was passed to the initialization function.
     */
    event DiamondCut(IDiamond.FacetCut[] facetCuts, address init, bytes initData);
}
