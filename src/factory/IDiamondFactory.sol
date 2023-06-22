// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Diamond } from "src/diamond/Diamond.sol";

interface IDiamondFactory {
    /**
     * @notice Deploys a clone to a diamond implementation, and performs an initial diamond cut.
     * @param implementation The address of the diamond implementation to clone.
     * @param initDiamondCut The initial diamond cut to perform.
     * @return diamond The address of the deployed clone.
     */
    function deployDiamondClone(
        address implementation,
        Diamond.InitParams memory initDiamondCut
    )
        external
        returns (address diamond);

    /**
     * @notice Deploys a deterministic clone to a diamond implementation, and performs an initial diamond cut.
     * @param implementation The address of the diamond implementation to clone.
     * @param salt The salt to use for the deterministic address.
     * @param initDiamondCut The initial diamond cut to perform.
     */
    function deployDiamondClone(
        address implementation,
        bytes32 salt,
        Diamond.InitParams memory initDiamondCut
    )
        external
        returns (address diamond);

    /**
     * @notice Deploys a beacon proxy to a diamond implementation, and performs an initial diamond cut.
     * @param beacon The address of the beacon which holds the diamond implementation.
     * @param initDiamondCut The initial diamond cut to perform.
     */
    function deployDiamondBeacon(
        address beacon,
        Diamond.InitParams memory initDiamondCut
    )
        external
        returns (address diamond);

    /**
     * @notice Deploys a deterministic beacon proxy to a diamond implementation, and performs an initial diamond cut.
     * @param beacon The address of the beacon which holds the diamond implementation.
     * @param salt The salt to use for the deterministic address.
     * @param initDiamondCut The initial diamond cut to perform.
     */
    function deployDiamondBeacon(
        address beacon,
        bytes32 salt,
        Diamond.InitParams memory initDiamondCut
    )
        external
        returns (address diamond);
}
