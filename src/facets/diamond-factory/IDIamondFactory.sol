// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Diamond } from "src/diamond/Diamond.sol";

interface IDiamondFactory {
    /**
     * @notice Deployes a new diamond proxy and applies an initial diamond cut.
     * @param initParams Struct containing the initial diamond cut params.
     */
    function createDiamond(Diamond.InitParams calldata initParams) external returns (address diamond);
}
