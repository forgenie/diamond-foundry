// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

interface IOwned {
    function owner() external view returns (address);
}

error Auth_CallerIsNotOwner();

abstract contract Auth {
    modifier onlyOwner() {
        if (msg.sender != IOwned(address(this)).owner()) revert Auth_CallerIsNotOwner();
        _;
    }
}
