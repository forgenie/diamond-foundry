// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { DiamondFactoryTest } from "../DiamondFactory.t.sol";
import { IERC173 } from "src/facets/ownable/IERC173.sol";
import { IERC165 } from "src/facets/introspection/IERC165.sol";

import { BaseFacetInfo } from "src/factory/DiamondFactory.sol";

// solhint-disable-next-line contract-name-camelcase
contract DiamondFactory_createDiamond is DiamondFactoryTest {
    function test_CreatesDiamond() public {
        BaseFacetInfo[] memory baseFacets = new BaseFacetInfo[](1);
        baseFacets[0] = BaseFacetInfo({ facetId: baseFacetId, initData: abi.encode(users.owner) });

        address diamond = diamondFactory.createDiamond(baseFacets);

        assertTrue(IERC165(diamond).supportsInterface(type(IERC173).interfaceId));
    }
}
