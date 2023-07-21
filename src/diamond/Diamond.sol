// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Proxy } from "@openzeppelin/contracts/proxy/Proxy.sol";
import { Initializable } from "src/utils/Initializable.sol";
import { DiamondCutBase } from "src/facets/cut/DiamondCutBase.sol";
import { DiamondLoupeBase } from "src/facets/loupe/DiamondLoupeBase.sol";
import { IDiamond } from "./IDiamond.sol";
import { DelegateContext } from "src/utils/DelegateContext.sol";

contract Diamond is IDiamond, Proxy, DiamondCutBase, DiamondLoupeBase, Initializable {
    struct InitParams {
        FacetCut[] baseFacets;
        address init;
        bytes initData;
    }

    constructor(InitParams memory initDiamondCut) initializer {
        _diamondCut(initDiamondCut.baseFacets, initDiamondCut.init, initDiamondCut.initData);
    }

    function _implementation() internal view override returns (address facet) {
        facet = _facetAddress(msg.sig);
        if (facet == address(0)) revert Diamond_UnsupportedFunction();
    }
}
