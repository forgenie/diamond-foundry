// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

/// @dev In a delegate call, address(this) will return diamond's address.
abstract contract DelegateContext {
    error DelegateNotAllowed();
    error OnlyDelegate();

    /**
     * @dev Stores the contract's address at the moment of deployment.
     *      Useful for detecting if a contract is being delegated to.
     */
    address internal immutable _self = address(this);

    modifier onlyDelegateCall() {
        if (address(this) == _self) revert OnlyDelegate();
        _;
    }

    modifier noDelegateCall() {
        if (address(this) != _self) revert DelegateNotAllowed();
        _;
    }
}
