// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

contract MockReverter {
    function justRevert() public pure {
        revert("Reverting");
    }

    function revertWithMessage(string memory message) public pure {
        revert(message);
    }
}
