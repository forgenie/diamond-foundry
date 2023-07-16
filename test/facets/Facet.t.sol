// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { BaseTest } from "../Base.t.sol";
import { DiamondFactory } from "src/factory/DiamondFactory.sol";
import { IDiamond, Diamond } from "src/diamond/Diamond.sol";
import { DiamondCutBase } from "src/facets/cut/DiamondCutBase.sol";

abstract contract FacetTest is BaseTest, DiamondFactory {
    address public constant MULTI_INIT_ADDRESS = 0xDeaDbeefdEAdbeefdEadbEEFdeadbeEFdEaDbeeF;

    /// @dev Attach facet interface to diamond for testing
    address public diamond;

    function setUp() public virtual override {
        super.setUp();

        address implementation = address(new Diamond());

        diamond = _deployDiamondClone(implementation, diamondInitParams());
    }

    /// @dev Add facet as init param for diamond
    function diamondInitParams() internal virtual returns (Diamond.InitParams memory);
}

abstract contract FacetHelper {
    /// @dev Deploy facet contract in ctor and return address for testing.
    function facet() public view virtual returns (address);

    function selectors() public view virtual returns (bytes4[] memory);

    function initializer() public view virtual returns (bytes4);

    function supportedInterfaces() public pure virtual returns (bytes4[] memory);

    function makeFacetCut(IDiamond.FacetCutAction action) public view returns (IDiamond.FacetCut memory) {
        return IDiamond.FacetCut({ action: action, facet: facet(), selectors: selectors() });
    }

    /// @dev Initializers accepting arguments can override this function
    //       and decode the arguments here.
    function makeInitData(bytes memory) public view virtual returns (IDiamond.MultiInit memory) {
        return IDiamond.MultiInit({ init: facet(), initData: abi.encodeWithSelector(initializer()) });
    }

    /// @dev Helper multiDelegateCall
    // function multiDelegateCall(IDiamond.MultiInit[] memory diamondInitData) external {
    //     for (uint256 i = 0; i < diamondInitData.length; i++) {
    //         IDiamond.MultiInit memory diamondInit = diamondInitData[i];

    //         Address.functionDelegateCall(diamondInit.init, diamondInit.initData);
    //     }
    // }
}
