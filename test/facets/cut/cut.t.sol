// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { FacetTest, FacetHelper, MULTI_INIT_ADDRESS, Diamond } from "test/facets/Facet.t.sol";
import { MockFacet, MockFacetHelper } from "test/mocks/MockFacet.sol";
import { IDiamondCutBase, IDiamondCut } from "src/facets/cut/IDiamondCut.sol";
import { DiamondCutFacet } from "src/facets/cut/DiamondCutFacet.sol";
import { DiamondLoupeFacetHelper } from "test/facets/loupe/loupe.t.sol";
import { OwnableFacetHelper } from "test/facets/ownable/ownable.t.sol";

abstract contract DiamondCutFacetTest is IDiamondCutBase, FacetTest {
    /// @dev helper to avoid boilerplate
    FacetCut[] public facetCuts;

    MockFacetHelper public mockFacetHelper;
    IDiamondCut public diamondCut;

    function setUp() public virtual override {
        super.setUp();

        diamondCut = IDiamondCut(diamond);
        mockFacetHelper = new MockFacetHelper();
    }

    function diamondInitParams() public override returns (Diamond.InitParams memory) {
        OwnableFacetHelper ownableHelper = new OwnableFacetHelper();
        DiamondCutFacetHelper diamondCutHelper = new DiamondCutFacetHelper();
        DiamondLoupeFacetHelper diamondLoupeHelper = new DiamondLoupeFacetHelper();

        FacetCut[] memory baseFacets = new FacetCut[](3);
        baseFacets[0] = ownableHelper.makeFacetCut(FacetCutAction.Add);
        baseFacets[1] = diamondCutHelper.makeFacetCut(FacetCutAction.Add);
        baseFacets[2] = diamondLoupeHelper.makeFacetCut(FacetCutAction.Add);

        MultiInit[] memory diamondInitData = new MultiInit[](3);
        diamondInitData[0] = ownableHelper.makeInitData(abi.encode(users.owner));
        diamondInitData[1] = diamondCutHelper.makeInitData("");
        diamondInitData[2] = diamondLoupeHelper.makeInitData("");

        return Diamond.InitParams({
            baseFacets: baseFacets,
            init: MULTI_INIT_ADDRESS,
            initData: abi.encode(diamondInitData)
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
        return diamondCut.DiamondCut_init.selector;
    }

    function supportedInterfaces() public pure override returns (bytes4[] memory interfaces) {
        interfaces = new bytes4[](1);
        interfaces[0] = type(IDiamondCut).interfaceId;
    }

    function creationCode() public pure override returns (bytes memory) {
        return type(DiamondCutFacet).creationCode;
    }
}
