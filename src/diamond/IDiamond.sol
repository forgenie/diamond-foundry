// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { IDiamondCut } from "src/facets/cut/IDiamondCut.sol";
import { IDiamondLoupe, IERC165 } from "src/facets/loupe/IDiamondLoupe.sol";

interface IDiamondBase {
    /// @notice Thrown when calling a function that was not registered in the diamond.
    error Diamond_UnsupportedFunction();
}

/**
 * @title IDiamond
 * @notice Interface of the Diamond Proxy contract. See [EIP-2535](https://eips.ethereum.org/EIPS/eip-2535).
 */
interface IDiamond is IDiamondBase, IDiamondCut, IDiamondLoupe {
    // todo: move into IDiamondBase
    /**
     * @notice Expresses the action of adding, replacing, or removing a facet.
     */
    enum FacetCutAction {
        Add,
        Replace,
        Remove
    }

    /**
     * @dev Describes a facet to be added, replaced or removed.
     * @param facet Address of the facet, that contains the functions.
     * @param action The action to be performed.
     * @param selectors The function selectors of the facet to be cut.
     */
    struct FacetCut {
        address facet;
        FacetCutAction action;
        bytes4[] selectors;
    }

    /**
     * @notice Represents data used in multiDelegateCall.
     * @param data Includes encoded initializer + arguments.
     */
    struct MultiInit {
        address init;
        bytes initData;
    }
}
