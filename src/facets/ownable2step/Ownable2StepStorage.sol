// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

library Ownable2StepStorage {
    bytes32 internal constant OWNABLE2STEP_STORAGE_SLOT = keccak256("diamond.ownable2step.storage");

    struct Layout {
        address pendingOwner;
    }

    function layout() internal pure returns (Layout storage l) {
        bytes32 position = OWNABLE2STEP_STORAGE_SLOT;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            l.slot := position
        }
    }
}
