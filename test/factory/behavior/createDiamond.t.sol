// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { DiamondFactoryTest } from "../DiamondFactory.t.sol";
import { DiamondContext } from "test/Diamond.t.sol";
import { IERC173 } from "src/facets/ownable/IERC173.sol";
import { IERC165 } from "src/facets/introspection/IERC165.sol";

// todo: test
// solhint-disable-next-line no-empty-blocks
abstract contract DiamondFactory_createDiamond is DiamondFactoryTest, DiamondContext { }
