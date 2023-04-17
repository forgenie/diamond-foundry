// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamondIncremental } from "src/facets/incremental/DiamondIncremental.sol";
import { IDiamondCut } from "src/facets/cut/DiamondCut.sol";
import { IDiamondLoupe } from "src/facets/loupe/DiamondLoupe.sol";
import { IERC173 } from "src/facets/ownable/Ownable.sol";
import { IERC165 } from "src/facets/introspection/Introspection.sol";

// solhint-disable-next-line no-empty-blocks
interface IDiamondBase is IDiamondIncremental, IDiamondCut, IDiamondLoupe, IERC173, IERC165 { }
