// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { DiamondCutBehavior, IDiamondCut, IDiamond } from "src/facets/cut/DiamondCutBehavior.sol";

abstract contract DiamondCut is IDiamondCut {
    /// @inheritdoc IDiamondCut
    function diamondCut(IDiamond.FacetCut[] calldata facetCuts, address init, bytes calldata initData) public {
        authorizeDiamondCut();
        DiamondCutBehavior.diamondCut(facetCuts, init, initData);
    }

    /// @dev Allows multiple possibilities for authorizing `diamondCut`.
    function authorizeDiamondCut() internal virtual;
}
