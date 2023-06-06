// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IERC721A } from "@erc721a/IERC721A.sol";
import { IBeacon } from "@openzeppelin/contracts/proxy/beacon/IBeacon.sol";
import { IDiamond } from "src/IDiamond.sol";
import { IFacetRegistry } from "src/registry/IFacetRegistry.sol";

interface IDiamondFoundryStructs {
    /**
     * @notice Contains the information for a base facet.
     * @dev Initializer is fetched from registry.
     * @param facetId The Id of the base facet.
     * @param initCalldata The calldata containing args for the initializer.
     */
    struct BaseFacet {
        bytes32 facetId;
        bytes initArgs;
    }

    /**
     * @notice Represents data used in multiDelegateCall.
     * @dev Initializer is fetched from registry.
     */
    struct FacetInit {
        address facet;
        bytes data;
    }
}

/**
 * @title IDiamondFoundry
 * @notice Interface of the Diamond Factory contract.
 */
interface IDiamondFoundry is IDiamondFoundryStructs, IERC721A, IBeacon {
    /**
     * @notice Emitted when a diamond is deployed via the factory.
     */
    event DiamondMinted(uint256 indexed tokenId, address indexed diamond);

    /**
     * @notice Creates a diamond with the given base Facets
     * @return diamond The address of the diamond.
     */
    function mintDiamond() external returns (address diamond);

    /**
     * @notice Returns the address of a diamond.
     */
    function diamondAddress(uint256 tokenId) external view returns (address);

    /**
     * @notice Returns the tokenId of a diamond.
     * @param diamond The address of the diamond.
     */
    function tokenIdOf(address diamond) external view returns (uint256);

    /**
     * @notice Returns the address of the `FacetRegistry`.
     */
    function facetRegistry() external view returns (IFacetRegistry);
}
