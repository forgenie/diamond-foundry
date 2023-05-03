// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

error DelegateCall_noDelegateCall_DelegateNotAllowed();
error DelegateCall_onlyDelegateCall_OnlyDelegate();

abstract contract DelegateCall {
    address private immutable _this = address(this);

    modifier onlyDelegateCall() {
        if (address(this) == _this) revert DelegateCall_onlyDelegateCall_OnlyDelegate();
        _;
    }

    modifier noDelegateCall() {
        if (address(this) != _this) revert DelegateCall_noDelegateCall_DelegateNotAllowed();
        _;
    }
}
