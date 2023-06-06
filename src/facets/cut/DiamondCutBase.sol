// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Initializable } from "src/utils/Initializable.sol";
import { IDiamond } from "src/IDiamond.sol";
import { IDiamondCut, IDiamondCutEvents } from "./IDiamondCut.sol";
import { DiamondCutBehavior } from "./DiamondCutBehavior.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";
import { OwnableBehavior } from "src/facets/ownable/OwnableBehavior.sol";

abstract contract DiamondCutBase is IDiamond, IDiamondCutEvents, Initializable {
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
                _checkImmutable(facetCut.facet, facetCut.selectors);

                DiamondCutBehavior.replaceFacet(facetCut.facet, facetCut.selectors);
            } else if (facetCut.action == IDiamond.FacetCutAction.Remove) {
                _checkImmutable(facetCut.facet, facetCut.selectors);

                DiamondCutBehavior.removeFacet(facetCut.facet, facetCut.selectors);
            }
        }

        emit DiamondCut(facetCuts, init, initData);

        DiamondCutBehavior.initializeDiamondCut(facetCuts, init, initData);
    }

    /// @dev Allows multiple possibilities making a facet immutable.
    ///      By default check that facet address not equals diamond.
    function _checkImmutable(address facet, bytes4[] memory selectors) internal view virtual {
        DiamondCutBehavior.checkImmutable(facet, selectors);
    }

    /// @dev Allows multiple possibilities for authorizing `diamondCut`.
    ///      By default check that sender is owner.
    function _authorizeDiamondCut() internal virtual {
        OwnableBehavior.checkOwner(msg.sender);
    }
}
