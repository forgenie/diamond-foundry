// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamondCut } from "./IDiamondCut.sol";
import { DiamondCutBehavior, IDiamond } from "./DiamondCutBehavior.sol";

abstract contract DiamondCut is IDiamondCut {
    /// @inheritdoc IDiamondCut
    function diamondCut(IDiamond.FacetCut[] memory facetCuts, address init, bytes memory initData) public {
        _authorizeDiamondCut();

        DiamondCutBehavior.diamondCut(facetCuts, init, initData);
    }

    /// @dev Allows multiple possibilities for authorizing `diamondCut`.
    function _authorizeDiamondCut() internal virtual;
}
