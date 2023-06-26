// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { SelfReferenced } from "./SelfReferenced.sol";

error DelegateCall_DelegateNotAllowed();
error DelegateCall_OnlyDelegate();

abstract contract DelegateCall is SelfReferenced {
    modifier onlyDelegateCall() {
        if (address(this) == _self) revert DelegateCall_OnlyDelegate();
        _;
    }

    modifier noDelegateCall() {
        if (address(this) != _self) revert DelegateCall_DelegateNotAllowed();
        _;
    }
}
