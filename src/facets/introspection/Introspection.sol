// SPDX-License-Identifier MIT License
pragma solidity 0.8.19;

import { IERC165 } from "./IERC165.sol";
import { IntrospectionBehavior } from "./IntrospectionBehavior.sol";
import { Facet } from "src/facets/BaseFacet.sol";

abstract contract Introspection is IERC165, Facet {
    function __Introspection_init() internal onlyInitializing {
        IntrospectionBehavior.addInterface(type(IERC165).interfaceId);
    }

    /// @inheritdoc IERC165
    function supportsInterface(bytes4 interfaceId) public view returns (bool) {
        return IntrospectionBehavior.supportsInterface(interfaceId);
    }
}
