// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { BaseTest } from "test/Base.t.sol";
import { MockDelegate } from "test/mocks/MockDelegate.sol";
import { DelegateContext } from "src/utils/DelegateContext.sol";

contract DelegateContextTest is BaseTest {
    MockDelegate public mockDelegate;

    function setUp() public override {
        super.setUp();

        mockDelegate = new MockDelegate();
    }

    function test_RevertsWhen_DelegateNotAllowed() public {
        bytes memory call = abi.encodeWithSelector(MockDelegate.incrementNoDelegate.selector);

        vm.expectRevert(DelegateContext.DelegateNotAllowed.selector);
        Address.functionDelegateCall(address(mockDelegate), call);
    }

    function test_IncrementsWithNoDelegate() public {
        mockDelegate.incrementNoDelegate();

        assertEq(mockDelegate.counter(), 1);
    }

    function test_RevertsWhen_OnlyDelegateAllowed() public {
        vm.expectRevert(DelegateContext.OnlyDelegate.selector);

        mockDelegate.incrementOnlyDelegate();
    }

    function test_IncrementsWithDelegate() public {
        bytes memory call = abi.encodeWithSelector(MockDelegate.incrementOnlyDelegate.selector);

        Address.functionDelegateCall(address(mockDelegate), call);

        assertEq(this.counter(), 1);
    }

    /// @dev takes counter from this contract's storage
    function counter() public view returns (uint256) {
        MockDelegate.Storage storage s;
        bytes32 position = mockDelegate.COUNTER_STORAGE_SLOT();

        // solhint-disable-next-line no-inline-assembly
        assembly {
            s.slot := position
        }
        return s.counter;
    }
}
