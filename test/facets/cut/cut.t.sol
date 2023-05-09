// SDPX-License-Identifier: MIT
pragma solidity 0.8.19;

import { MockFacet, MockFacetHelper } from "test/mocks/MockFacet.sol";
import { BaseTest } from "test/Base.t.sol";
import { IDiamond, IDiamondCut, DiamondCutFacet } from "src/facets/cut/DiamondCutFacet.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";
import { FacetHelper } from "test/facets/Helpers.t.sol";

abstract contract DiamondCutBehaviorTest is BaseTest {
    MockFacetHelper public mockFacetHelper;

    event DiamondCut(IDiamond.FacetCut[] facetCuts, address init, bytes initData);

    function setUp() public virtual override {
        super.setUp();

        mockFacetHelper = new MockFacetHelper();
        IntrospectionBehavior.addInterface(type(IDiamondCut).interfaceId);
    }
}

contract DiamondCutFacetHelper is FacetHelper {
    DiamondCutFacet public diamondCut;

    constructor() {
        diamondCut = new DiamondCutFacet();
    }

    function facet() public view override returns (address) {
        return address(diamondCut);
    }

    function selectors() public view override returns (bytes4[] memory selectors_) {
        selectors_ = new bytes4[](1);
        selectors_[0] = diamondCut.diamondCut.selector;
    }

    function initializer() public view override returns (bytes4) {
        return diamondCut.initialize.selector;
    }

    function name() public pure override returns (string memory) {
        return "DiamondCut";
    }

    function supportedInterfaces() public pure override returns (bytes4[] memory interfaces) {
        interfaces = new bytes4[](1);
        interfaces[0] = type(IDiamondCut).interfaceId;
    }
}
