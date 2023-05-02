// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamondIncremental } from "src/facets/incremental/IDiamondIncremental.sol";
import { IDiamondCut } from "src/facets/cut/IDiamondCut.sol";
import { IDiamondLoupe } from "src/facets/loupe/IDiamondLoupe.sol";
import { IERC173 } from "src/facets/ownable/IERC173.sol";
import { IERC165 } from "src/facets/introspection/IERC165.sol";

// solhint-disable-next-line no-empty-blocks
interface IDiamondBase is IDiamondIncremental, IDiamondCut, IDiamondLoupe, IERC173, IERC165 { }
