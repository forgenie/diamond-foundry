// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { IDiamond } from "src/diamond/IDiamond.sol";
import { IDiamondCut, IDiamondCutBase } from "./IDiamondCut.sol";
import { DiamondCutStorage } from "./DiamondCutStorage.sol";
import { MULTI_INIT_ADDRESS } from "src/Constants.sol";

abstract contract DiamondCutBase is IDiamondCutBase {
    using EnumerableSet for *;

    function _diamondCut(IDiamond.FacetCut[] memory facetCuts, address init, bytes memory initData) internal {
        for (uint256 i = 0; i < facetCuts.length; i++) {
            IDiamond.FacetCut memory facetCut = facetCuts[i];

            _validateFacetCut(facetCut);

            if (facetCut.action == IDiamond.FacetCutAction.Add) {
                _addFacet(facetCut.facet, facetCut.selectors);
            } else if (facetCut.action == IDiamond.FacetCutAction.Replace) {
                _replaceFacet(facetCut.facet, facetCut.selectors);
            } else if (facetCut.action == IDiamond.FacetCutAction.Remove) {
                _removeFacet(facetCut.facet, facetCut.selectors);
            }
        }

        emit DiamondCut(facetCuts, init, initData);

        _initializeDiamondCut(facetCuts, init, initData);
    }

    function _addFacet(address facet, bytes4[] memory selectors) internal {
        DiamondCutStorage.Layout storage ds = DiamondCutStorage.layout();

        // slither-disable-next-line unused-return
        ds.facets.add(facet);
        for (uint256 i = 0; i < selectors.length; i++) {
            bytes4 selector = selectors[i];

            if (selector == bytes4(0)) {
                revert DiamondCut_SelectorIsZero();
            }
            if (ds.selectorToFacet[selector] != address(0)) {
                revert DiamondCut_FunctionAlreadyExists(selector);
            }

            ds.selectorToFacet[selector] = facet;
            // slither-disable-next-line unused-return
            ds.facetSelectors[facet].add(selector);
        }
    }

    function _replaceFacet(address facet, bytes4[] memory selectors) internal {
        DiamondCutStorage.Layout storage ds = DiamondCutStorage.layout();

        // slither-disable-next-line unused-return
        ds.facets.add(facet);
        for (uint256 i = 0; i < selectors.length; i++) {
            bytes4 selector = selectors[i];
            address oldFacet = ds.selectorToFacet[selector];

            if (selector == bytes4(0)) {
                revert DiamondCut_SelectorIsZero();
            }
            if (oldFacet == address(this)) {
                revert DiamondCut_ImmutableFacet();
            }
            if (oldFacet == facet) {
                revert DiamondCut_FunctionFromSameFacet(selector);
            }
            if (oldFacet == address(0)) {
                revert DiamondCut_NonExistingFunction(selector);
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

    function _removeFacet(address facet, bytes4[] memory selectors) internal {
        DiamondCutStorage.Layout storage ds = DiamondCutStorage.layout();

        for (uint256 i = 0; i < selectors.length; i++) {
            bytes4 selector = selectors[i];
            // also reverts if left side returns zero address
            if (selector == bytes4(0)) {
                revert DiamondCut_SelectorIsZero();
            }
            if (facet == address(this)) {
                revert DiamondCut_ImmutableFacet();
            }
            if (ds.selectorToFacet[selector] != facet) {
                revert DiamondCut_CannotRemoveFromOtherFacet(facet, selector);
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

    function _validateFacetCut(IDiamond.FacetCut memory facetCut) internal view {
        if (uint256(facetCut.action) > 2) {
            revert DiamondCut_IncorrectFacetCutAction();
        }
        if (facetCut.facet == address(0)) {
            revert DiamondCut_FacetIsZeroAddress();
        }
        if (!Address.isContract(facetCut.facet)) {
            revert DiamondCut_FacetIsNotContract(facetCut.facet);
        }
        if (facetCut.selectors.length == 0) {
            revert DiamondCut_SelectorArrayEmpty(facetCut.facet);
        }
    }

    function _initializeDiamondCut(IDiamond.FacetCut[] memory, address init, bytes memory initData) internal {
        if (init == address(0)) return;
        if (init == MULTI_INIT_ADDRESS) {
            _multiDelegateCall(abi.decode(initData, (IDiamond.MultiInit[])));
            return;
        }
        if (!Address.isContract(init)) {
            revert DiamondCut_InitIsNotContract(init);
        }
        // slither-disable-next-line unused-return
        Address.functionDelegateCall(init, initData);
    }

    function _multiDelegateCall(IDiamond.MultiInit[] memory initData) internal {
        uint256 length = initData.length;
        for (uint256 i = 0; i < length; i++) {
            address init = initData[i].init;
            if (!Address.isContract(init)) {
                revert DiamondCut_InitIsNotContract(init);
            }
            // slither-disable-next-line unused-return
            Address.functionDelegateCall(init, initData[i].initData);
        }
    }
}
