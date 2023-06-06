// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { IDiamondFoundry } from "./IDiamondFoundry.sol";
import { IDiamond } from "./IDiamond.sol";
import { DiamondCutBase } from "./facets/cut/DiamondCutBase.sol";
import { DiamondLoupeBehavior } from "./facets/loupe/DiamondLoupeBehavior.sol";

error Diamond_Fallback_UnsupportedFunction();

// todo: DEPRECATE this in favor of DiamondBase
contract Diamond is IDiamond, DiamondCutBase {
    struct InitParams {
        FacetCut[] baseFacets;
        address init;
        bytes initData;
    }

    constructor(InitParams memory params) {
        // Initializer on `init` will set up the state
        // NOTE: If `diamondCut` facet is not provided, the diamond will be immutable
        _diamondCut(params.baseFacets, params.init, params.initData);
    }

    fallback() external {
        _fallback();
    }

    receive() external payable {
        _fallback();
    }

    /// IDEA: Allow fallback function to be implemented/overriden by a base facet.
    /// This would allow different customization possibilities,
    /// such as delegate directly the `FacetRegistry` where Facets can be upgraded
    function _fallback() internal {
        address facet = DiamondLoupeBehavior.facetAddress(msg.sig);

        if (facet == address(0)) revert Diamond_Fallback_UnsupportedFunction();

        // slither-disable-next-line unused-return
        Address.functionDelegateCall(facet, msg.data);

        // solhint-disable-next-line no-inline-assembly
        assembly {
            // get return value
            returndatacopy(0, 0, returndatasize())
            // return return value or error back to the caller
            return(0, returndatasize())
        }
    }

    // solhint-disable-next-line no-empty-blocks
    function _authorizeDiamondCut() internal override { }
}
