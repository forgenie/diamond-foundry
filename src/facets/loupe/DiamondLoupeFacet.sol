// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { Facet } from "src/facets/Facet.sol";
import { IDiamondLoupe } from "./IDiamondLoupe.sol";
import { DiamondLoupeBase } from "./DiamondLoupeBase.sol";
import { IERC165 } from "src/facets/introspection/IERC165.sol";
import { IntrospectionBase } from "src/facets/introspection/IntrospectionBase.sol";

contract DiamondLoupeFacet is IDiamondLoupe, IERC165, DiamondLoupeBase, IntrospectionBase, Facet {
    function DiamondLoupe_init() external onlyInitializing {
        __DiamondLoupe_init();
        __Introspection_init();
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
