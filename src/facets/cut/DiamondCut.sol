// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamondCut } from "./IDiamondCut.sol";
import { DiamondCutBehavior, IDiamond } from "./DiamondCutBehavior.sol";
import { Facet } from "src/facets/BaseFacet.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";

abstract contract DiamondCut is IDiamondCut, Facet {
    function __DiamondCut_init() internal onlyInitializing {
        IntrospectionBehavior.addInterface(type(IDiamondCut).interfaceId);
    }

    /// @inheritdoc IDiamondCut
    function diamondCut(IDiamond.FacetCut[] memory facetCuts, address init, bytes memory initData) public {
        _authorizeDiamondCut();

        DiamondCutBehavior.diamondCut(facetCuts, init, initData);
    }

    /// @dev Allows multiple possibilities for authorizing `diamondCut`.
    function _authorizeDiamondCut() internal virtual;
}
