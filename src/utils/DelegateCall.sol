// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { SelfReferenced } from "./SelfReferenced.sol";
import { IAccessControl } from "src/facets/access-control/IAccessControl.sol";
import { IERC173 } from "src/facets/ownable/IERC173.sol";

error DelegateCall_DelegateNotAllowed();
error DelegateCall_OnlyDelegate();
error DelegateCall_DelegateCall_CallerIsNotOwner();
error DelegateCall_CallerIsNotOwner();

/// @dev In a delegate call, address(this) will return diamond's address.
abstract contract DelegateCall is SelfReferenced {
    modifier onlyDelegateCall() {
        if (address(this) == _self) revert DelegateCall_OnlyDelegate();
        _;
    }

    modifier noDelegateCall() {
        if (address(this) != _self) revert DelegateCall_DelegateNotAllowed();
        _;
    }

    modifier onlyOwner() {
        if (msg.sender != IERC173(address(this)).owner()) revert DelegateCall_CallerIsNotOwner();
        _;
    }

    modifier onlyAuthorized() {
        if (!IAccessControl(address(this)).canCall(msg.sender, msg.sig)) revert DelegateCall_CallerIsNotOwner();
        _;
    }
}
