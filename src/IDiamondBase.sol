// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IDiamondCut } from "./facets/cut/IDiamondCut.sol";
import { IDiamondLoupe } from "./facets/loupe/IDiamondLoupe.sol";
import { IERC165 } from "./facets/introspection/IERC165.sol";
import { IDiamondFoundry } from "./factory/IDiamondFoundry.sol";

interface IDiamondBase is IDiamondCut, IDiamondLoupe, IERC165 {
    function diamondFoundry() external view returns (IDiamondFoundry);

    function owner() external view returns (address);
}
