// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Initializable } from "src/utils/Initializable.sol";
import { IDiamond } from "src/diamond/IDiamond.sol";
import { IDiamondCut, IDiamondCutEvents } from "./IDiamondCut.sol";
import { DiamondCutBehavior } from "./DiamondCutBehavior.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";

abstract contract DiamondCutBase is IDiamondCutEvents, Initializable {
    function __DiamondCut_init() internal onlyInitializing {
        IntrospectionBehavior.addInterface(type(IDiamondCut).interfaceId);
    }

    function _diamondCut(IDiamond.FacetCut[] memory facetCuts, address init, bytes memory initData) internal {
        for (uint256 i = 0; i < facetCuts.length; i++) {
            IDiamond.FacetCut memory facetCut = facetCuts[i];

            DiamondCutBehavior.validateFacetCut(facetCut);

            if (facetCut.action == IDiamond.FacetCutAction.Add) {
                DiamondCutBehavior.addFacet(facetCut.facet, facetCut.selectors);
            } else if (facetCut.action == IDiamond.FacetCutAction.Replace) {
                DiamondCutBehavior.replaceFacet(facetCut.facet, facetCut.selectors);
            } else if (facetCut.action == IDiamond.FacetCutAction.Remove) {
                DiamondCutBehavior.removeFacet(facetCut.facet, facetCut.selectors);
            }
        }

        emit DiamondCut(facetCuts, init, initData);

        DiamondCutBehavior.initializeDiamondCut(facetCuts, init, initData);
    }
}
