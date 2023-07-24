// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { NFTOwnedTest } from "../nft-owned.t.sol";

contract NFTOwned_owner is NFTOwnedTest {
    function test_ReturnsOwner() public {
        address nftOwner = tokenContract.ownerOf(tokenId);

        assertEq(nftOwned.owner(), nftOwner);
    }

    function test_ReturnsOwner_AfterTransfer() public {
        address newOwner = address(2);
        address nftOwner = tokenContract.ownerOf(tokenId);
        vm.startPrank(nftOwner);
        tokenContract.transferFrom(nftOwner, newOwner, tokenId);

        assertEq(nftOwned.owner(), newOwner);
    }
}
