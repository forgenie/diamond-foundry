// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Diamond } from "src/Diamond.sol";
import { FacetTest } from "test/facets/Facet.t.sol";
import { FacetInit } from "src/factory/IDiamondFactory.sol";
import { FacetHelper } from "test/facets/Helpers.t.sol";
import { MockFacetHelper } from "test/mocks/MockFacet.sol";
import { IDiamondIncremental, DiamondIncrementalFacet } from "src/facets/incremental/DiamondIncrementalFacet.sol";
import { DiamondCutFacetHelper } from "test/facets/cut/cut.t.sol";
import { OwnableFacetHelper } from "test/facets/ownable/ownable.t.sol";

abstract contract DiamondIncrementalFacetTest is FacetTest {
    event SelectorTurnedImmutable(bytes4 indexed selector);

    IDiamondIncremental public diamondIncremental;
    MockFacetHelper public mockFacet;

    function setUp() public virtual override {
        super.setUp();

        diamondIncremental = IDiamondIncremental(diamond);
        mockFacet = new MockFacetHelper();
    }

    function diamondInitParams() internal override returns (Diamond.InitParams memory) {
        DiamondIncrementalFacetHelper diamondIncrementalFacetHelper = new DiamondIncrementalFacetHelper();
        DiamondCutFacetHelper diamondCutFacetHelper = new DiamondCutFacetHelper();
        OwnableFacetHelper ownableFacetHelper = new OwnableFacetHelper();

        FacetCut[] memory baseFacets = new FacetCut[](3);
        baseFacets[0] = diamondIncrementalFacetHelper.makeFacetCut(FacetCutAction.Add);
        baseFacets[1] = diamondCutFacetHelper.makeFacetCut(FacetCutAction.Add);
        baseFacets[2] = ownableFacetHelper.makeFacetCut(FacetCutAction.Add);

        FacetInit[] memory diamondInitData = new FacetInit[](3);
        diamondInitData[0] = diamondIncrementalFacetHelper.makeInitData("");
        diamondInitData[1] = diamondCutFacetHelper.makeInitData("");
        diamondInitData[2] = ownableFacetHelper.makeInitData(abi.encode(users.owner));

        return Diamond.InitParams({
            baseFacets: baseFacets,
            init: address(diamondIncrementalFacetHelper),
            initData: abi.encodeWithSelector(diamondIncrementalFacetHelper.multiDelegateCall.selector, diamondInitData)
        });
    }
}

contract DiamondIncrementalFacetHelper is FacetHelper {
    DiamondIncrementalFacet public diamondIncremental;

    constructor() {
        diamondIncremental = new DiamondIncrementalFacet();
    }

    function facet() public view override returns (address) {
        return address(diamondIncremental);
    }

    function selectors() public view override returns (bytes4[] memory selectors_) {
        selectors_ = new bytes4[](2);
        selectors_[0] = diamondIncremental.turnImmutable.selector;
        selectors_[1] = diamondIncremental.isImmutable.selector;
    }

    function initializer() public view override returns (bytes4) {
        return diamondIncremental.initialize.selector;
    }

    function name() public pure override returns (string memory) {
        return "DiamondIncremental";
    }

    function supportedInterfaces() public pure override returns (bytes4[] memory interfaces) {
        interfaces = new bytes4[](1);
        interfaces[0] = type(IDiamondIncremental).interfaceId;
    }
}
