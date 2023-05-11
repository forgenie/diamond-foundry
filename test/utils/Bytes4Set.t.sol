// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { BaseTest } from "../Base.t.sol";
import { EnumerableBytes4Set } from "src/utils/Bytes4Set.sol";

contract Bytes4SetTest is BaseTest {
    using EnumerableBytes4Set for EnumerableBytes4Set.Bytes4Set;

    EnumerableBytes4Set.Bytes4Set private bytes4Set;

    function test_Bytes4_Add() public {
        bytes4 value = bytes4(0x12345678);
        assertTrue(bytes4Set.add(value));
        assertTrue(bytes4Set.contains(value));
        assertEq(bytes4Set.length(), 1);
    }
}
