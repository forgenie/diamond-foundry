// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { StdCheats, StdUtils } from "forge-std/Test.sol";

abstract contract BaseTest is PRBTest, StdCheats, StdUtils {
    struct Users {
        address payable admin;
        address payable owner;
        address payable stranger;
    }

    Users public users;

    function setUp() public virtual {
        users = Users(createUser("admin"), createUser("owner"), createUser("stranger"));

        // Prank owner by default
        vm.startPrank(users.owner);
    }

    /// @dev Creates a new account and funds it with 100 ETH.
    function createUser(string memory name) public returns (address payable addr) {
        addr = payable(makeAddr(name));
        vm.deal(addr, 100 ether);
    }
}
