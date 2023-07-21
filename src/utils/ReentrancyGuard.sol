// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

abstract contract ReentrancyGuard {
    error ReentrantCall();

    bytes32 private constant _REENTRANCY_GUARD_SLOT = keccak256("utils.reentrancy.guard");
    uint256 private constant _NOT_ENTERED = 0;
    uint256 private constant _ENTERED = 1;

    struct Storage {
        uint256 status;
    }

    modifier nonReentrant() {
        if (layout().status == _ENTERED) revert ReentrantCall();

        layout().status = _ENTERED;
        _;
        layout().status = _NOT_ENTERED;
    }

    function layout() private pure returns (Storage storage s) {
        bytes32 position = _REENTRANCY_GUARD_SLOT;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            s.slot := position
        }
    }
}
