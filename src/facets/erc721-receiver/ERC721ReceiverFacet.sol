// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { IERC721Receiver } from "./IERC721Receiver.sol";

contract ERC721ReceiverFacet is IERC721Receiver {
    function onERC721Received(address, address, uint256, bytes memory) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}
