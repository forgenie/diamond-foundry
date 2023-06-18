// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IDiamondCut } from "src/facets/cut/IDiamondCut.sol";
import { IDiamondLoupe } from "src/facets/loupe/IDiamondLoupe.sol";
import { IERC165 } from "src/facets/introspection/IERC165.sol";

interface IDiamondBase is IDiamondCut, IDiamondLoupe, IERC165 { }
