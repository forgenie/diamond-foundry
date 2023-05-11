// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { Address } from "@openzeppelin/contracts/utils/Address.sol";

import { IDiamond } from "src/IDiamond.sol";
import { DiamondCutStorage } from "./DiamondCutStorage.sol";

error DiamondCut_validateFacetCut_SelectorArrayEmpty(address facet);
error DiamondCut_validateFacetCut_FacetIsZeroAddress();
error DiamondCut_validateFacetCut_FacetIsNotContract(address facet);
error DiamondCut_validateFacetCut_IncorrectFacetCutAction();
error DiamondCut_addFacet_SelectorIsZero();
error DiamondCut_addFacet_FunctionAlreadyExists(bytes4 selector);
error DiamondCut_removeFacet_CannotRemoveFromOtherFacet(address facet, bytes4 selector);
error DiamondCut_removeFacet_SelectorIsZero();
error DiamondCut_replaceFacet_SelectorIsZero();
error DiamondCut_replaceFacet_FunctionFromSameFacet(bytes4 selector);
error DiamondCut_replaceFacet_InexistingFunction(bytes4 selector);
error DiamondCut_checkImmutable_ImmutableFacet();
error DiamondCut_initializeDiamondCut_InitIsNotContract(address init);

library DiamondCutBehavior {
    /**
     * -------------- Abstraction methods for accessing DiamondCutStorage --------------
     */
    using DiamondCutStorage for DiamondCutStorage.Layout;
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    function addFacet(address facet, bytes4[] memory selectors) internal {
        DiamondCutStorage.Layout storage ds = DiamondCutStorage.layout();

        // slither-disable-next-line unused-return
        ds.facets.add(facet);
        for (uint256 i = 0; i < selectors.length; i++) {
            bytes4 selector = selectors[i];

            if (selector == bytes4(0)) {
                revert DiamondCut_addFacet_SelectorIsZero();
            }
            if (ds.selectorToFacet[selector] != address(0)) {
                revert DiamondCut_addFacet_FunctionAlreadyExists(selector);
            }

            ds.selectorToFacet[selector] = facet;
            // slither-disable-next-line unused-return
            ds.facetSelectors[facet].add(selector);
        }
    }

    function removeFacet(address facet, bytes4[] memory selectors) internal {
        DiamondCutStorage.Layout storage ds = DiamondCutStorage.layout();

        for (uint256 i = 0; i < selectors.length; i++) {
            bytes4 selector = selectors[i];
            // also reverts if left side returns zero address
            if (selector == bytes4(0)) {
                revert DiamondCut_removeFacet_SelectorIsZero();
            }
            if (ds.selectorToFacet[selector] != facet) {
                revert DiamondCut_removeFacet_CannotRemoveFromOtherFacet(facet, selector);
            }

            delete ds.selectorToFacet[selector];
            // slither-disable-next-line unused-return
            ds.facetSelectors[facet].remove(selector);
            // if no more selectors in facet, remove facet address
            if (ds.facetSelectors[facet].length() == 0) {
                // slither-disable-next-line unused-return
                ds.facets.remove(facet);
            }
        }
    }

    function replaceFacet(address facet, bytes4[] memory selectors) internal {
        DiamondCutStorage.Layout storage ds = DiamondCutStorage.layout();

        // slither-disable-next-line unused-return
        ds.facets.add(facet);
        for (uint256 i = 0; i < selectors.length; i++) {
            bytes4 selector = selectors[i];
            address oldFacet = ds.selectorToFacet[selector];

            if (selector == bytes4(0)) {
                revert DiamondCut_replaceFacet_SelectorIsZero();
            }
            if (oldFacet == facet) {
                revert DiamondCut_replaceFacet_FunctionFromSameFacet(selector);
            }
            if (oldFacet == address(0)) {
                revert DiamondCut_replaceFacet_InexistingFunction(selector);
            }

            // overwrite selector to new facet
            ds.selectorToFacet[selector] = facet;

            // slither-disable-next-line unused-return
            ds.facetSelectors[facet].add(selector);

            // slither-disable-next-line unused-return
            ds.facetSelectors[oldFacet].remove(selector);

            // if no more selectors, remove old facet address
            if (ds.facetSelectors[oldFacet].length() == 0) {
                // slither-disable-next-line unused-return
                ds.facets.remove(oldFacet);
            }
        }
    }

    function validateFacetCut(IDiamond.FacetCut memory facetCut) internal view {
        if (uint256(facetCut.action) > 2) {
            revert DiamondCut_validateFacetCut_IncorrectFacetCutAction();
        }
        if (facetCut.facet == address(0)) {
            revert DiamondCut_validateFacetCut_FacetIsZeroAddress();
        }
        if (!Address.isContract(facetCut.facet)) {
            revert DiamondCut_validateFacetCut_FacetIsNotContract(facetCut.facet);
        }
        if (facetCut.selectors.length == 0) {
            revert DiamondCut_validateFacetCut_SelectorArrayEmpty(facetCut.facet);
        }
    }

    function checkImmutable(address facet, bytes4[] memory) internal view {
        if (facet == address(this)) revert DiamondCut_checkImmutable_ImmutableFacet();
    }

    function initializeDiamondCut(IDiamond.FacetCut[] memory, address init, bytes memory initData) internal {
        if (init == address(0)) return;

        if (!Address.isContract(init)) {
            revert DiamondCut_initializeDiamondCut_InitIsNotContract(init);
        }

        // slither-disable-next-line unused-return
        Address.functionDelegateCall(init, initData);
    }
}
