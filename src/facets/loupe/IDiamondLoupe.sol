// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { IERC165 } from "@openzeppelin/contracts/interfaces/IERC165.sol";

interface IDiamondLoupeBase {
    struct Facet {
        address facet;
        bytes4[] selectors;
    }
}

/**
 * @title IDiamondLoupe
 * @notice A loupe is a small magnifying glass used to look at diamonds.
 *         See [EIP-2535](https://eips.ethereum.org/EIPS/eip-2535).
 */
interface IDiamondLoupe is IDiamondLoupeBase, IERC165 {
    /**
     * @notice Gets all facet addresses and the selectors of supported functions.
     * @return facetInfo An array of Facet structs.
     */
    function facets() external view returns (Facet[] memory);

    /**
     * @notice Gets all the function selectors supported by a specific facet.
     * @param facet The facet address.
     * @return selectors An array of function selectors.
     */
    function facetFunctionSelectors(address facet) external view returns (bytes4[] memory);

    /**
     * @notice Get all the facet addresses used by a diamond.
     * @return facets The facet addresses.
     */
    function facetAddresses() external view returns (address[] memory);

    /**
     * @notice Gets the facet that supports the given selector.
     * @dev If facet is not found return address(0).
     * @param selector The function selector.
     * @return facetAddress The facet address.
     */
    function facetAddress(bytes4 selector) external view returns (address);
}
