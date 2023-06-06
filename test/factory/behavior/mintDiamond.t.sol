// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { DiamondFoundryTest } from "../DiamondFoundry.t.sol";
import { IDiamondBase, DiamondBase, DiamondBase_Fallback_CallerIsNotDiamond } from "src/diamond/DiamondBase.sol";

contract DiamondFoundry_mintDiamond is DiamondFoundryTest {
    function test_ZeroTokenIdIsMinted() public {
        assertEq(diamondFoundry.ownerOf(0), address(diamondFoundry));
    }

    function test_MintDiamond() public {
        address diamond = diamondFoundry.mintDiamond();

        assertEq(diamondFoundry.ownerOf(1), users.owner);
        assertEq(diamondFoundry.diamondAddress(1), diamond);
        assertEq(diamondFoundry.tokenIdOf(diamond), 1);
    }

    function test_RevertsWhen_NonTokenDelegates() public {
        address diamondBase = diamondFoundry.implementation();

        vm.expectRevert(DiamondBase_Fallback_CallerIsNotDiamond.selector);

        Address.functionDelegateCall(diamondBase, abi.encodeWithSelector(DiamondBase.facets.selector));
    }

    function test_TokenDelegates() public {
        address diamond = diamondFoundry.mintDiamond();

        bytes4[] memory selectors = IDiamondBase(diamond).facetFunctionSelectors(diamond);

        assertEq(selectors.length, 8);
    }
}
