// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IDiamondFactory {
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
     * @param data Includes encoded initializer + arguments.
     */
    struct FacetInit {
        address facet;
        bytes data;
    }
}
