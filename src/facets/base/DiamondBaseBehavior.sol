// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

// implements interface
import { IDiamondBase } from "./IDiamondBase.sol";

// uses storage
import { DiamondBaseStorage } from "./DiamondBaseStorage.sol";

// uses behavior
import { IntrospectionBehavior } from "./introspection/IntrospectionBehavior.sol";
import { IDiamondCut } from "./cut/IDiamondCut.sol";

error DiamondBase_immute_AlreadyImmutable(bytes4 selector);
error DiamondBase_checkDiamondFactory_InvalidDiamondFactory();

library DiamondBaseBehavior {
    function isImmutable(bytes4 selector) internal view returns (bool) {
        // if `diamondCut` method was removed all functions are immutable
        if (!IntrospectionBehavior.supportsInterface(type(IDiamondCut).interfaceId)) {
            return true;
        }
        return DiamondBaseStorage.layout().immutableFunctions[selector];
    }

    /// @notice Sets multiple functions as immutable.
    //          A granular alternative to removing the `diamondCut` method.
    function immute(bytes4[] memory selectors) internal {
        DiamondBaseStorage.Layout storage ds = DiamondBaseStorage.layout();

        for (uint256 i; i < selectors.length; i++) {
            bytes4 selector = selectors[i];

            if (isImmutable(selector)) {
                revert DiamondBase_immute_AlreadyImmutable(selector);
            }

            ds.immutableFunctions[selectors[i]] = true;
        }
    }

    function diamondFactory() internal view returns (address) {
        return DiamondBaseStorage.layout().diamondFactory;
    }

    function checkDiamondFactory(address factory) internal view {
        if (diamondFactory() != factory) {
            revert DiamondBase_checkDiamondFactory_InvalidDiamondFactory();
        }
    }
}
