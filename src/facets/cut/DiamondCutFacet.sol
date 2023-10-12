// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.20;

import { IDiamondCut, IDiamond } from "./IDiamondCut.sol";
import { Facet } from "src/facets/Facet.sol";
import { DiamondCutBase } from "./DiamondCutBase.sol";

contract DiamondCutFacet is IDiamondCut, DiamondCutBase, Facet {
    function DiamondCut_init() external onlyInitializing {
        _addInterface(type(IDiamondCut).interfaceId);
    }

    /// @inheritdoc IDiamondCut
    function diamondCut(
        IDiamond.FacetCut[] memory facetCuts,
        address init,
        bytes memory initData
    )
        external
        onlyDiamondOwner
        reinitializer(_getInitializedVersion() + 1)
    {
        _diamondCut(facetCuts, init, initData);
    }
}
