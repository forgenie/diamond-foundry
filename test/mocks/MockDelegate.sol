// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { DelegateCall } from "src/utils/DelegateCall.sol";

contract MockDelegate is DelegateCall {
    bytes32 public constant COUNTER_STORAGE_SLOT = keccak256("MockDelegate.counter.storage");

    struct Storage {
        uint256 counter;
    }

    function incrementNoDelegate() public noDelegateCall {
        layout().counter++;
    }

    function incrementOnlyDelegate() public onlyDelegateCall {
        layout().counter++;
    }

    function counter() public view returns (uint256) {
        return layout().counter;
    }

    function layout() internal pure returns (Storage storage s) {
        bytes32 position = COUNTER_STORAGE_SLOT;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            s.slot := position
        }
    }
}
