// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

interface IDiamondFactoryBase {
    /// @notice Thrown when the created diamond does not have loupe facet.
    error DiamondFactory_LoupeNotSupported();

    /// @notice Emitted when a diamond is created.
    event DiamondCreated(address indexed diamond, address indexed deployer);
}
