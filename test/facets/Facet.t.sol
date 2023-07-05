// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { BaseTest } from "../Base.t.sol";
import { DiamondFactory } from "src/factory/DiamondFactory.sol";
import { IDiamond, Diamond } from "src/diamond/Diamond.sol";
import { IFacetRegistry } from "src/registry/IFacetRegistry.sol";

abstract contract FacetTest is BaseTest, DiamondFactory {
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

    function facetId() public view virtual returns (bytes32) {
        return facet().codehash;
    }

    function supportedInterfaces() public pure virtual returns (bytes4[] memory);

    function facetInfo() public view returns (IFacetRegistry.FacetInfo memory info) {
        info = IFacetRegistry.FacetInfo({ addr: facet(), initializer: initializer(), selectors: selectors() });
    }

    function makeFacetCut(IDiamond.FacetCutAction action) public view returns (IDiamond.FacetCut memory) {
        return IDiamond.FacetCut({ action: action, facet: facet(), selectors: selectors() });
    }

    /// @dev Initializers accepting arguments can override this function
    //       and decode the arguments here.
    function makeInitData(bytes memory) public view virtual returns (IDiamond.FacetInit memory) {
        return IDiamond.FacetInit({ facet: facet(), data: abi.encodeWithSelector(initializer()) });
    }

    /// @dev Helper multiDelegateCall
    function multiDelegateCall(IDiamond.FacetInit[] memory diamondInitData) external {
        for (uint256 i = 0; i < diamondInitData.length; i++) {
            IDiamond.FacetInit memory facetInit = diamondInitData[i];

            Address.functionDelegateCall(facetInit.facet, facetInit.data);
        }
    }
}
