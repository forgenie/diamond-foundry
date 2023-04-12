// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { DiamondFactoryTest } from "../DiamondFactory.t.sol";
import { IERC173 } from "src/facets/ownable/IERC173.sol";
import { IERC165 } from "src/facets/introspection/IERC165.sol";

// solhint-disable-next-line contract-name-camelcase
contract DiamondFactory_createDiamond is DiamondFactoryTest {
    function test_createDiamond() public {
        address owner = address(this);
        address diamond = diamondFactory.createDiamond(baseFacetId);

        assertTrue(IERC173(diamond).owner() == owner);
        assertTrue(IERC165(diamond).supportsInterface(type(IERC173).interfaceId));
    }
}
