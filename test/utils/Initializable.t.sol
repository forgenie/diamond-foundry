// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { BaseTest } from "../Base.t.sol";
import { MockInitializable } from "test/mocks/MockInitializable.sol";
import {
    Initializable_initializer_AlreadyInitialized,
    Initializable_reinitializer_AlreadyInitialized,
    Initializable_onlyInitializing_NotInInitializingState,
    Initializable_disableInitializers_InInitializingState
} from "src/utils/Initializable.sol";

contract InitializableTest is BaseTest {
    event Initialized(uint8 version);

    MockInitializable public mock;

    function setUp() public override {
        super.setUp();

        mock = new MockInitializable();
    }

    function test_RevertsWhen_AlreadyInitialized() public {
        mock.initialize();

        vm.expectRevert(Initializable_initializer_AlreadyInitialized.selector);

        mock.initialize();
    }

    function testFuzz_RevertsWhen_InitializersAreDisabled(uint8 version) public {
        mock.disableInitializers();

        vm.expectRevert(Initializable_initializer_AlreadyInitialized.selector);

        mock.initialize();

        vm.expectRevert(
            abi.encodeWithSelector(Initializable_reinitializer_AlreadyInitialized.selector, type(uint8).max)
        );

        mock.reinitialize(version);
    }

    function test_RevertsWhen_DoubleInitializer() public {
        vm.expectRevert(Initializable_initializer_AlreadyInitialized.selector);

        mock.doubleInitializer();
    }

    function test_RevertsWhen_NonInitializer() public {
        vm.expectRevert(Initializable_onlyInitializing_NotInInitializingState.selector);

        mock.nonInitializer();
    }

    function test_RevertsWhen_DisabledInitializer() public {
        vm.expectRevert(Initializable_disableInitializers_InInitializingState.selector);

        mock.disabledInitializer();
    }

    function testFuzz_RevertsWhen_ReinitializingWithSmallerVersion(uint8 currVersion, uint8 newVersion) public {
        vm.assume(currVersion > 1);
        newVersion = uint8(bound(newVersion, 1, currVersion - 1));

        mock.reinitialize(currVersion);

        vm.expectRevert(abi.encodeWithSelector(Initializable_reinitializer_AlreadyInitialized.selector, currVersion));

        mock.reinitialize(newVersion);
    }

    function test_InitializesContract() public {
        vm.expectEmit();
        emit Initialized(1);

        mock.initialize();
    }

    function testFuzz_ReinitializesContract(uint8 version) public {
        vm.assume(version > 1);

        mock.initialize();

        vm.expectEmit();
        emit Initialized(version);

        mock.reinitialize(version);
    }
}
