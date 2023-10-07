// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.20;

import { NFTOwnedTest } from "../nft-owned.t.sol";

contract NFTOwned_token is NFTOwnedTest {
    function test_ReturnsToken() public {
        (address tokenContract_, uint256 tokenId_) = nftOwned.token();

        assertEq(address(tokenContract), tokenContract_);
        assertEq(tokenId, tokenId_);
    }
}
