// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { BaseTest } from "../Base.t.sol";
import { MockInitializable } from "test/mocks/MockInitializable.sol";
import { Initializable } from "src/utils/Initializable.sol";

contract InitializableTest is BaseTest {
    event Initialized(uint32 version);

    MockInitializable public mock;

    function setUp() public override {
        super.setUp();

        mock = new MockInitializable();
    }

    function test_RevertsWhen_AlreadyInitialized() public {
        mock.initialize();

        vm.expectRevert(abi.encodeWithSelector(Initializable.AlreadyInitialized.selector, 1));

        mock.initialize();
    }

    function testFuzz_RevertsWhen_InitializersAreDisabled(uint32 version) public {
        mock.disableInitializers();

        vm.expectRevert(abi.encodeWithSelector(Initializable.AlreadyInitialized.selector, type(uint32).max));

        mock.initialize();

        vm.expectRevert(abi.encodeWithSelector(Initializable.AlreadyInitialized.selector, type(uint32).max));

        mock.reinitialize(version);
    }

    function test_RevertsWhen_DoubleInitializer() public {
        vm.expectRevert(abi.encodeWithSelector(Initializable.AlreadyInitialized.selector, 1));

        mock.doubleInitializer();
    }

    function test_RevertsWhen_NonInitializer() public {
        vm.expectRevert(Initializable.NotInInitializingState.selector);

        mock.nonInitializer();
    }

    function test_RevertsWhen_DisabledInitializer() public {
        vm.expectRevert(Initializable.InInitializingState.selector);

        mock.disabledInitializer();
    }

    function testFuzz_RevertsWhen_ReinitializingWithSmallerVersion(uint32 currVersion, uint32 newVersion) public {
        vm.assume(currVersion > 1);
        newVersion = uint32(bound(newVersion, 1, currVersion - 1));

        mock.reinitialize(currVersion);

        vm.expectRevert(abi.encodeWithSelector(Initializable.AlreadyInitialized.selector, currVersion));

        mock.reinitialize(newVersion);
    }

    function test_InitializesContract() public {
        vm.expectEmit();
        emit Initialized(1);

        mock.initialize();
    }

    function testFuzz_ReinitializesContract(uint32 version) public {
        vm.assume(version > 1);

        mock.initialize();

        vm.expectEmit();
        emit Initialized(version);

        mock.reinitialize(version);
    }
}
