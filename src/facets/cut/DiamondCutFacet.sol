// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
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
        reinitializer(_nextVersion())
    {
        _diamondCut(facetCuts, init, initData);
    }
}
