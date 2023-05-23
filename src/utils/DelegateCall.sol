// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { SelfReferenced } from "./SelfReferenced.sol";

error DelegateCall_noDelegateCall_DelegateNotAllowed();
error DelegateCall_onlyDelegateCall_OnlyDelegate();

abstract contract DelegateCall is SelfReferenced {
    modifier onlyDelegateCall() {
        if (address(this) == _self) revert DelegateCall_onlyDelegateCall_OnlyDelegate();
        _;
    }

    modifier noDelegateCall() {
        if (address(this) != _self) revert DelegateCall_noDelegateCall_DelegateNotAllowed();
        _;
    }
}
