// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { BaseTest } from "../Base.t.sol";
import { IDiamond, Diamond } from "src/diamond/Diamond.sol";
import { DiamondCutBase } from "src/facets/cut/DiamondCutBase.sol";
import { MULTI_INIT_ADDRESS } from "src/Constants.sol";

abstract contract FacetTest is BaseTest, IDiamond {
    /// @dev Attach facet interface to diamond for testing
    address public diamond;

    function setUp() public virtual override {
        super.setUp();

        diamond = address(new Diamond(diamondInitParams()));
    }

    /// @dev Add facet as init param for diamond
    function diamondInitParams() public virtual returns (Diamond.InitParams memory);
}

abstract contract FacetHelper is IDiamond {
    /// @dev Deploy facet contract in ctor and return address for testing.
    function facet() public view virtual returns (address);

    function selectors() public view virtual returns (bytes4[] memory);

    function initializer() public view virtual returns (bytes4);

    function supportedInterfaces() public pure virtual returns (bytes4[] memory);

    function makeFacetCut(FacetCutAction action) public view returns (FacetCut memory) {
        return FacetCut({ action: action, facet: facet(), selectors: selectors() });
    }

    /// @dev Initializers accepting arguments can override this function
    //       and decode the arguments here.
    function makeInitData(bytes memory) public view virtual returns (MultiInit memory) {
        return MultiInit({ init: facet(), initData: abi.encodeWithSelector(initializer()) });
    }

    function creationCode() public pure virtual returns (bytes memory);
}
