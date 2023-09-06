// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Diamond, FacetTest, FacetHelper } from "test/facets/Facet.t.sol";
import { DiamondFactory, IDiamondFactory } from "src/factory/DiamondFactory.sol";
import { IDiamondFactoryBase } from "src/factory/IDiamondFactoryBase.sol";

abstract contract DiamondFactoryTest is IDiamondFactoryBase, FacetTest {
    IDiamondFactory public diamondFactory;

    function setUp() public virtual override {
        super.setUp();

        diamondFactory = IDiamondFactory(diamond);
    }

    function diamondInitParams() public override returns (Diamond.InitParams memory) {
        DiamondFactoryHelper diamondFactoryHelper = new DiamondFactoryHelper();

        FacetCut[] memory baseFacets = new FacetCut[](1);
        baseFacets[0] = diamondFactoryHelper.makeFacetCut(FacetCutAction.Add);

        return Diamond.InitParams({ baseFacets: baseFacets, init: address(0), initData: "" });
    }
}

contract DiamondFactoryHelper is FacetHelper {
    DiamondFactory public diamondFactoryFacet;

    constructor() {
        diamondFactoryFacet = new DiamondFactory();
    }

    function facet() public view override returns (address) {
        return address(diamondFactoryFacet);
    }

    function initializer() public pure override returns (bytes4) {
        return bytes4(0);
    }

    function selectors() public pure override returns (bytes4[] memory selectors_) {
        selectors_ = new bytes4[](1);
        selectors_[0] = DiamondFactory.createDiamond.selector;
    }

    function supportedInterfaces() public pure override returns (bytes4[] memory interfaces) {
        interfaces = new bytes4[](1);
        interfaces[0] = type(IDiamondFactory).interfaceId;
    }

    function creationCode() public pure override returns (bytes memory) {
        return type(DiamondFactory).creationCode;
    }
}
