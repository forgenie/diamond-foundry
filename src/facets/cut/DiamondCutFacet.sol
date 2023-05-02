// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamondCut } from "./IDiamondCut.sol";
import { Facet } from "src/facets/BaseFacet.sol";
import { DiamondCutBehavior, IDiamond } from "./DiamondCutBehavior.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";
import { OwnableBehavior } from "src/facets/ownable/OwnableBehavior.sol";

contract DiamondCutFacet is IDiamondCut, Facet {
    function __DiamondCut_init() internal onlyInitializing {
        IntrospectionBehavior.addInterface(type(IDiamondCut).interfaceId);
    }

    function initialize() external initializer {
        __DiamondCut_init();
    }

    /// @inheritdoc IDiamondCut
    function diamondCut(IDiamond.FacetCut[] memory facetCuts, address init, bytes memory initData) public {
        _authorizeDiamondCut();

        DiamondCutBehavior.diamondCut(facetCuts, init, initData);
    }

    /// @dev Allows multiple possibilities for authorizing `diamondCut`.
    function _authorizeDiamondCut() internal virtual {
        OwnableBehavior.checkOwner(_msgSender());
    }
}
