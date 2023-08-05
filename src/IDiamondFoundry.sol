// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { IERC721A } from "@erc721a/IERC721A.sol";
import { Diamond } from "src/diamond/Diamond.sol";
import { IFacetRegistry } from "src/registry/IFacetRegistry.sol";

/**
 * @title IDiamondFoundry
 * @notice Registers all facets and deploys new diamond proxies.
 * @dev The final contract should be a diamond itself, with ERC721A functionality abstracted in a facet.
 */
interface IDiamondFoundry is IFacetRegistry, IERC721A {
    /// @notice Emitted when a diamond is deployed without IDiamondLoupe interface.
    error DiamondFoundry_LoupeNotSupported();

    /**
     * @notice Emitted when a diamond is deployed via the factory.
     */
    event DiamondMinted(uint256 indexed tokenId, address indexed diamond);

    /**
     * @notice Creates a diamond with the given base Facets
     * @return diamond The address of the diamond.
     * todo: create generic createDiamond(Diamond.InitParams calldata initParams) function.
     */
    function mintDiamond(Diamond.InitParams calldata initParams) external returns (address diamond);

    /**
     * @notice Returns the addresses of given diamonds, based on tokenIds.
     * @param tokenIds The tokenIds of the diamonds.
     * @return diamonds The addresses of the diamonds.
     */
    function diamondAddresses(uint256[] calldata tokenIds) external view returns (address[] memory diamonds);

    /**
     * @notice Returns the tokenIds of given diamonds, based on addresses.
     * @param diamonds The addresses of the diamonds.
     * @return tokenIds The tokenIds of the diamonds.
     */
    function diamondIds(address[] calldata diamonds) external view returns (uint256[] memory tokenIds);

    /**
     * @notice Returns the address of a diamond from a tokenId.
     * @param tokenId The tokenId of the diamond.
     */
    function diamondAddress(uint256 tokenId) external view returns (address);

    /**
     * @notice Returns the tokenId of a diamond.
     * @param diamond The address of the diamond.
     */
    function diamondId(address diamond) external view returns (uint256);
}
