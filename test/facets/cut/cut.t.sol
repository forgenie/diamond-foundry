// SDPX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IDiamond, Diamond } from "src/Diamond.sol";
import { MockFacet, MockFacetHelper } from "test/mocks/MockFacet.sol";
import { IDiamondCutEvents, IDiamondCut } from "src/facets/cut/IDiamondCut.sol";
import { DiamondCutFacet } from "src/facets/cut/DiamondCutFacet.sol";
import { IntrospectionBehavior } from "src/facets/introspection/IntrospectionBehavior.sol";
import { FacetHelper } from "test/facets/Helpers.t.sol";
import { FacetTest } from "test/facets/Facet.t.sol";
import { OwnableFacetHelper } from "test/facets/ownable/ownable.t.sol";

abstract contract DiamondCutFacetTest is IDiamondCutEvents, FacetTest {
    /// @dev helper to avoid boilerplate
    FacetCut[] public facetCuts;

    MockFacetHelper public mockFacetHelper;
    IDiamondCut public diamondCut;

    function setUp() public virtual override {
        super.setUp();

        diamondCut = IDiamondCut(diamond);
        mockFacetHelper = new MockFacetHelper();
    }

    function diamondInitParams() internal override returns (Diamond.InitParams memory) {
        DiamondCutFacetHelper diamondCutHelper = new DiamondCutFacetHelper();
        OwnableFacetHelper ownableHelper = new OwnableFacetHelper();

        FacetCut[] memory baseFacets = new FacetCut[](2);
        baseFacets[0] = diamondCutHelper.makeFacetCut(FacetCutAction.Add);
        baseFacets[1] = ownableHelper.makeFacetCut(FacetCutAction.Add);

        FacetInit[] memory diamondInitData = new FacetInit[](2);
        diamondInitData[0] = diamondCutHelper.makeInitData("");
        diamondInitData[1] = ownableHelper.makeInitData(abi.encode(users.owner));

        return Diamond.InitParams({
            baseFacets: baseFacets,
            init: address(diamondCutHelper),
            initData: abi.encodeWithSelector(diamondCutHelper.multiDelegateCall.selector, diamondInitData)
        });
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
