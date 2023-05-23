// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

abstract contract SelfReferenced {
    /**
     * @dev Stores the contract's address at the moment of deployment.
     *      Useful for detecting if a contract is being delegated to.
     */
    address internal immutable _self = address(this);
}
