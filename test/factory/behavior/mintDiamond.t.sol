// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { DiamondFoundryTest } from "../DiamondFoundry.t.sol";
import { IDiamond, Diamond } from "src/diamond/Diamond.sol";

contract DiamondFoundry_mintDiamond is DiamondFoundryTest {
    function test_ZeroTokenIdIsMinted() public {
        assertEq(diamondFoundry.ownerOf(0), address(diamondFoundry));
    }

    function test_MintDiamond() public {
        address diamond = diamondFoundry.mintDiamond();

        assertEq(diamondFoundry.ownerOf(1), users.owner);
        assertEq(diamondFoundry.diamondAddress(1), diamond);
        assertEq(diamondFoundry.diamondId(diamond), 1);
    }
}
