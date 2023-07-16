// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { Facet } from "src/facets/Facet.sol";
import { IERC165, IDiamondLoupe } from "./IDiamondLoupe.sol";
import { DiamondLoupeBase } from "./DiamondLoupeBase.sol";

contract DiamondLoupeFacet is IDiamondLoupe, DiamondLoupeBase, Facet {
    function DiamondLoupe_init() external onlyInitializing {
        _addInterface(type(IDiamondLoupe).interfaceId);
        _addInterface(type(IERC165).interfaceId);
    }

    /// @inheritdoc IDiamondLoupe
    function facets() external view returns (Facet[] memory) {
        return _facets();
    }

    /// @inheritdoc IDiamondLoupe
    function facetFunctionSelectors(address facet) external view returns (bytes4[] memory) {
        return _facetSelectors(facet);
    }

    /// @inheritdoc IDiamondLoupe
    function facetAddresses() external view returns (address[] memory) {
        return _facetAddresses();
    }

    /// @inheritdoc IDiamondLoupe
    function facetAddress(bytes4 selector) external view returns (address) {
        return _facetAddress(selector);
    }

    /// @inheritdoc IERC165
    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return _supportsInterface(interfaceId);
    }
}
