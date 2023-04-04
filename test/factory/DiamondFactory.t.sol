// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { BaseTest } from "../Base.t.sol";
import { IFacetRegistry, FacetRegistry } from "src/registry/FacetRegistry.sol";
import { DiamondFactory } from "src/factory/DiamondFactory.sol";
import { DiamondBaseFacet } from "src/facets/base/DiamondBaseFacet.sol";

abstract contract DiamondFactoryTest is BaseTest {
    DiamondFactory diamondFactory;
    FacetRegistry facetRegistry;
    DiamondBaseFacet diamondBaseFacet;

    function setUp() public virtual override {
        super.setUp();

        facetRegistry = new FacetRegistry();
        diamondBaseFacet = new DiamondBaseFacet();

        string memory name = "DiamondBase";
        bytes4[] memory selectors = new bytes4[](11);
        selectors[0] = diamondBaseFacet.immute.selector;
        selectors[1] = diamondBaseFacet.isImmutable.selector;
        selectors[2] = diamondBaseFacet.diamondFactory.selector;
        selectors[3] = diamondBaseFacet.diamondCut.selector;
        selectors[4] = diamondBaseFacet.facets.selector;
        selectors[5] = diamondBaseFacet.facetFunctionSelectors.selector;
        selectors[6] = diamondBaseFacet.facetAddresses.selector;
        selectors[7] = diamondBaseFacet.facetAddress.selector;
        selectors[8] = diamondBaseFacet.supportsInterface.selector;
        selectors[9] = diamondBaseFacet.owner.selector;
        selectors[10] = diamondBaseFacet.transferOwnership.selector;

        IFacetRegistry.FacetInfo memory facetInfo = IFacetRegistry.FacetInfo({
            name: name,
            addr: address(diamondBaseFacet),
            initializer: diamondBaseFacet.initialize.selector,
            selectors: selectors
        });
        facetRegistry.registerFacet(facetInfo);

        diamondFactory = new DiamondFactory(facetRegistry);
    }
}
