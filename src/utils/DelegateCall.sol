// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { SelfReferenced } from "./SelfReferenced.sol";
import { IAccessControl } from "src/facets/access-control/IAccessControl.sol";
import { IERC173 } from "src/facets/ownable/IERC173.sol";

error DelegateContext_DelegateNotAllowed();
error DelegateContext_OnlyDelegate();
error DelegateContext_DelegateContext_CallerIsNotOwner();
error DelegateContext_CallerIsNotOwner();

/// @dev In a delegate call, address(this) will return diamond's address.
abstract contract DelegateContext is SelfReferenced {
    modifier onlyDelegateCall() {
        if (address(this) == _self) revert DelegateContext_OnlyDelegate();
        _;
    }

    modifier noDelegateCall() {
        if (address(this) != _self) revert DelegateContext_DelegateNotAllowed();
        _;
    }

    modifier onlyOwner() {
        if (msg.sender != IERC173(address(this)).owner()) revert DelegateContext_CallerIsNotOwner();
        _;
    }

    modifier onlyAuthorized() {
        if (!IAccessControl(address(this)).canCall(msg.sender, msg.sig)) revert DelegateContext_CallerIsNotOwner();
        _;
    }
}
