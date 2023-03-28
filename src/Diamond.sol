// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamond } from "./IDiamond.sol";
import { DiamondCutStorage } from "./facets/base/cut/DiamondCutStorage.sol";

error Diamond_Fallback_UnsupportedFunction();

contract Diamond is IDiamond {
    struct InitParams {
        address owner;
    }

    fallback() external {
        _fallback();
    }

    receive() external payable {
        _fallback();
    }

    function _fallback() internal {
        address facet = DiamondCutStorage.layout().selectorToFacet[msg.sig];

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
