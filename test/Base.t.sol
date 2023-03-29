// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { StdCheats } from "forge-std/Test.sol";

import { MockFacet } from "test/mocks/MockFacet.sol";

abstract contract BaseTest is PRBTest, StdCheats {
    struct Users {
        address payable owner;
        address payable stranger;
    }

    MockFacet public mockFacet;

    Users public users;

    function setUp() public virtual {
        users = Users(createUser("owner"), createUser("stranger"));

        mockFacet = new MockFacet();
    }

    /// @dev Creates a new account and funds it with 100 ETH.
    function createUser(string memory name) public returns (address payable addr) {
        addr = payable(makeAddr(name));
        vm.deal(addr, 100 ether);
    }

    /// @dev Expects an event to be emitted.
    function expectEmit() public {
        vm.expectEmit(true, true, true, true);
    }

    /// @dev Expects an event to be emitted with the given emitter.
    function expectEmit(address emitter) public {
        vm.expectEmit(true, true, true, true, emitter);
    }
}
