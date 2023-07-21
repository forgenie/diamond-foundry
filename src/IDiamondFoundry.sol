// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { IERC721A } from "@erc721a/IERC721A.sol";
import { Diamond } from "src/diamond/Diamond.sol";
import { IFacetRegistry } from "src/registry/IFacetRegistry.sol";

/**
 * @title IDiamondFoundry
 * @notice Interface of the Diamond Factory contract.
 */
interface IDiamondFoundry is IFacetRegistry, IERC721A {
    /**
     * @notice Emitted when a diamond is deployed via the factory.
     */
    event DiamondMinted(uint256 indexed tokenId, address indexed diamond);

    /**
     * @notice Creates a diamond with the given base Facets
     * @return diamond The address of the diamond.
     */
    function mintDiamond(Diamond.InitParams calldata initParams) external returns (address diamond);

    /**
     * @notice Returns the address of a diamond.
     */
    function diamondAddress(uint256 tokenId) external view returns (address);

    /**
     * @notice Returns the tokenId of a diamond.
     * @param diamond The address of the diamond.
     */
    function diamondId(address diamond) external view returns (uint256);
}
