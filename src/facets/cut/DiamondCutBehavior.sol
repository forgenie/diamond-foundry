// SPDX-License-Identifier: MIT License
// solhint-disable avoid-low-level-calls
pragma solidity 0.8.19;

import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { Address } from "@openzeppelin/contracts/utils/Address.sol";

import { DiamondCutStorage } from "./DiamondCutStorage.sol";

import { IDiamond } from "src/IDiamond.sol";
import { DiamondIncrementalBehavior } from "src/facets/incremental/DiamondIncrementalBehavior.sol";

error DiamondCut_validateFacetCut_SelectorArrayEmpty(address facet);
error DiamondCut_validateFacetCut_FacetIsZeroAddress();
error DiamondCut_validateFacetCut_FacetIsNotContract(address facet);
error DiamondCut_validateFacetCut_IncorrectFacetCutAction();
error DiamondCut_addFacet_SelectorIsZero();
error DiamondCut_addFacet_FacetSelectorAlreadyExists(bytes4 selector);
error DiamondCut_addFacet_FunctionAlreadyExists(bytes4 selector);
error DiamondCut_removeFacet_CannotRemoveFromOtherFacet(address facet, bytes4 selector);
error DiamondCut_removeFacet_SelectorIsZero();
error DiamondCut_removeFacet_ImmutableFunction(bytes4 selector);
error DiamondCut_replaceFacet_SelectorIsZero();
error DiamondCut_replaceFacet_FunctionFromSameFacet(bytes4 selector);
error DiamondCut_replaceFacet_InexistingFunction(bytes4 selector);
error DiamondCut_replaceFacet_ImmutableFunction(bytes4 selector);
error DiamondCut_initializeDiamondCut_InitializationReverted();
error DiamondCut_initializeDiamondCut_InitIsNotContract(address init);

library DiamondCutBehavior {
    /**
     * -------------- Abstraction methods for accessing DiamondCutStorage --------------
     */
    using DiamondCutStorage for DiamondCutStorage.Layout;
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    function getFacetAddresses() internal view returns (address[] memory facets) {
        return DiamondCutStorage.layout().facets.values();
    }

    function getFacetFromSelector(bytes4 selector) internal view returns (address facet) {
        return DiamondCutStorage.layout().selectorToFacet[selector];
    }

    function getFacetSelectors(address facet) internal view returns (bytes4[] memory selectors) {
        EnumerableSet.Bytes32Set storage facetSelectors = DiamondCutStorage.layout().facetSelectors[facet];
        uint256 selectorCount = facetSelectors.length();
        selectors = new bytes4[](selectorCount);
        for (uint256 i = 0; i < selectorCount; i++) {
            selectors[i] = bytes4(facetSelectors.at(i));
        }
    }

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
            if (DiamondIncrementalBehavior.isImmutable(selector)) {
                revert DiamondCut_removeFacet_ImmutableFunction(selector);
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

        for (uint256 i = 0; i < selectors.length; i++) {
            bytes4 selector = selectors[i];
            address oldFacet = ds.selectorToFacet[selector];

            if (selector == bytes4(0)) {
                revert DiamondCut_replaceFacet_SelectorIsZero();
            }
            if (DiamondIncrementalBehavior.isImmutable(selector)) {
                revert DiamondCut_replaceFacet_ImmutableFunction(selector);
            }
            if (oldFacet == facet) {
                revert DiamondCut_replaceFacet_FunctionFromSameFacet(selector);
            }
            if (oldFacet == address(0)) {
                revert DiamondCut_replaceFacet_InexistingFunction(selector);
            }

            // slither-disable-next-line unused-return
            ds.facets.add(facet);

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
    /**
     * -------------- Methods containing actual Behavior --------------
     * These methods are not using DiamondCutStorage directly for getting and setting storage
     */

    /// @dev We redeclare the event here because Solidity does not allow emitting events from other interfaces.
    event DiamondCut(IDiamond.FacetCut[] facetCuts, address init, bytes initData);

    function diamondCut(IDiamond.FacetCut[] memory facetCuts, address init, bytes memory initData) internal {
        for (uint256 i = 0; i < facetCuts.length; i++) {
            IDiamond.FacetCut memory facetCut = facetCuts[i];

            validateFacetCut(facetCut);

            if (facetCut.action == IDiamond.FacetCutAction.Add) {
                addFacet(facetCut.facet, facetCut.selectors);
            } else if (facetCut.action == IDiamond.FacetCutAction.Replace) {
                replaceFacet(facetCut.facet, facetCut.selectors);
            } else if (facetCut.action == IDiamond.FacetCutAction.Remove) {
                removeFacet(facetCut.facet, facetCut.selectors);
            }
        }

        emit DiamondCut(facetCuts, init, initData);

        initializeDiamondCut(facetCuts, init, initData);
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

    function initializeDiamondCut(IDiamond.FacetCut[] memory, address init, bytes memory initData) internal {
        if (init == address(0)) return;

        // TODO: add multicall initialization to diamondFactory
        if (!Address.isContract(init)) {
            revert DiamondCut_initializeDiamondCut_InitIsNotContract(init);
        }

        // is this necessary ?? delegate call should revert anyway
        // slither-disable-next-line low-level-calls
        (bool success, bytes memory error) = init.delegatecall(initData);
        if (!success) {
            if (error.length > 0) {
                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(error)
                    revert(add(32, error), returndata_size)
                }
            } else {
                revert DiamondCut_initializeDiamondCut_InitializationReverted();
            }
        }
    }
}
