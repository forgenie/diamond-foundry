// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

contract MockReverter {
    function justRevert() public pure {
        // solhint-disable-next-line custom-errors
        revert("Reverting");
    }

    function revertWithMessage(string memory message) public pure {
        revert(message);
    }
}
