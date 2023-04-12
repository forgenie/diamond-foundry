// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IERC173 } from "./IERC173.sol";
import { OwnableBehavior } from "./OwnableBehavior.sol";

abstract contract Ownable is IERC173 {
    modifier onlyOwner() {
        OwnableBehavior.checkOwner(msg.sender);
        _;
    }

    /// @inheritdoc IERC173
    function owner() public view returns (address) {
        return OwnableBehavior.owner();
    }

    /// @inheritdoc IERC173
    function transferOwnership(address newOwner) public onlyOwner {
        OwnableBehavior.transferOwnership(newOwner);
    }
}
