// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamondFactory } from "./factory/IDiamondFactory.sol";
import { IDiamond } from "./IDiamond.sol";
import { DiamondCutBehavior } from "./facets/base/cut/DiamondCutBehavior.sol";

error Diamond_Fallback_UnsupportedFunction();

contract Diamond is IDiamond {
    struct InitParams {
        FacetCut[] baseFacets;
        address init;
        bytes initData;
    }

    constructor() {
        InitParams memory params = IDiamondFactory(msg.sender).parameters();

        // Initializer on `init` will set up the state
        // NOTE: If `diamondCut` facet is not provided, the diamond will be immutable
        DiamondCutBehavior.diamondCut(params.baseFacets, params.init, params.initData);
    }

    fallback() external {
        _fallback();
    }

    receive() external payable {
        _fallback();
    }

    /// IDEA: Allow fallback function to be implemented/overriden by a base facet
    ///       This would allow different customization possibilities
    ///       Such as delegate directly from facets in the `FacetRegistry` which can be upgraded there
    function _fallback() internal {
        address facet = DiamondCutBehavior.getFacetFromSelector(msg.sig);

        if (facet == address(0)) revert Diamond_Fallback_UnsupportedFunction();

        // Execute external function from facet using delegatecall and return any value.
        assembly {
            // copy function selector and any arguments
            calldatacopy(0, 0, calldatasize())
            // execute function call using the facet
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            // get any return value
            returndatacopy(0, 0, returndatasize())
            // return any return value or error back to the caller
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }
}
