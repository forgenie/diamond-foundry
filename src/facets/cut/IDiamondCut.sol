// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { IDiamond } from "src/IDiamond.sol";
import { IDiamondCutBase } from "./IDiamondCutBase.sol";

/**
 * @title IDiamondCut
 * @notice Interface of the DiamondCut facet. See [EIP-2535](https://eips.ethereum.org/EIPS/eip-2535).
 */
interface IDiamondCut is IDiamondCutBase {
    /**
     * @notice Add/replace/remove any number of functions and optionally execute
     *         a function with delegatecall.
     * @param facetCuts Contains the facet addresses and function selectors.
     * @param init The address of the contract or facet to execute initData.
     * @param initData A function call, including function selector and arguments
     *                 executed with delegatecall on address init.
     */
    function diamondCut(IDiamond.FacetCut[] calldata facetCuts, address init, bytes calldata initData) external;
}
