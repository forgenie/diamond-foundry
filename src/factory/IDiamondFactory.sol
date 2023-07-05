// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Diamond } from "src/diamond/Diamond.sol";

interface IDiamondFactory {
    /**
     * @notice Deploys a clone to a diamond implementation, and performs an initial diamond cut.
     * @param diamond The address of the diamond implementation to clone.
     * @param initDiamondCut The initial diamond cut to perform.
     * @return clone The address of the deployed clone.
     */
    function deployDiamondClone(
        address diamond,
        Diamond.InitParams memory initDiamondCut
    )
        external
        returns (address clone);

    /**
     * @notice Deploys a deterministic clone to a diamond implementation, and performs an initial diamond cut.
     * @param diamond The address of the diamond implementation to clone.
     * @param salt The salt to use for the deterministic address.
     * @param initDiamondCut The initial diamond cut to perform.
     */
    function deployDiamondClone(
        address diamond,
        bytes32 salt,
        Diamond.InitParams memory initDiamondCut
    )
        external
        returns (address clone);

    /**
     * @notice Deploys a beacon proxy to a diamond implementation, and performs an initial diamond cut.
     * @param diamondBeacon The address of the beacon which holds the diamond implementation.
     * @param initDiamondCut The initial diamond cut to perform.
     */
    function deployDiamondBeacon(
        address diamondBeacon,
        Diamond.InitParams memory initDiamondCut
    )
        external
        returns (address beaconProxy);

    /**
     * @notice Deploys a deterministic beacon proxy to a diamond implementation, and performs an initial diamond cut.
     * @param diamondBeacon The address of the beacon which holds the diamond implementation.
     * @param salt The salt to use for the deterministic address.
     * @param initDiamondCut The initial diamond cut to perform.
     */
    function deployDiamondBeacon(
        address diamondBeacon,
        bytes32 salt,
        Diamond.InitParams memory initDiamondCut
    )
        external
        returns (address beaconProxy);
}
