// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { Auth } from "src/auth/Auth.sol";
import { IDiamondCut, IDiamond } from "./IDiamondCut.sol";
import { Facet } from "src/facets/Facet.sol";
import { DiamondCutBase } from "./DiamondCutBase.sol";

contract DiamondCutFacet is IDiamondCut, DiamondCutBase, Facet, Auth {
    function DiamondCut_init() external onlyInitializing {
        __DiamondCut_init();
    }

    /// @inheritdoc IDiamondCut
    function diamondCut(IDiamond.FacetCut[] memory facetCuts, address init, bytes memory initData) external onlyOwner {
        _diamondCut(facetCuts, init, initData);
    }
}
