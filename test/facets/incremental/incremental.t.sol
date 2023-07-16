// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { FacetTest, FacetHelper } from "test/facets/Facet.t.sol";
import { IDiamond, Diamond } from "src/diamond/Diamond.sol";
import { IDiamondIncremental, IDiamondIncrementalBase } from "src/facets/incremental/IDiamondIncremental.sol";
import { DiamondIncrementalFacet } from "src/facets/incremental/DiamondIncrementalFacet.sol";
import { MockFacetHelper } from "test/mocks/MockFacet.sol";
import { DiamondCutFacetHelper } from "test/facets/cut/cut.t.sol";
import { OwnableFacetHelper } from "test/facets/ownable/ownable.t.sol";

abstract contract DiamondIncrementalFacetTest is IDiamondIncrementalBase, FacetTest {
    IDiamondIncremental public diamondIncremental;
    MockFacetHelper public mockFacet;

    function setUp() public virtual override {
        super.setUp();

        diamondIncremental = IDiamondIncremental(diamond);
        mockFacet = new MockFacetHelper();
    }

    function diamondInitParams() internal override returns (Diamond.InitParams memory) {
        DiamondIncrementalFacetHelper diamondIncrementalHelper = new DiamondIncrementalFacetHelper();
        OwnableFacetHelper ownableHelper = new OwnableFacetHelper();

        IDiamond.FacetCut[] memory baseFacets = new IDiamond.FacetCut[](2);
        baseFacets[0] = diamondIncrementalHelper.makeFacetCut(IDiamond.FacetCutAction.Add);
        baseFacets[1] = ownableHelper.makeFacetCut(IDiamond.FacetCutAction.Add);

        IDiamond.MultiInit[] memory diamondInitData = new IDiamond.MultiInit[](2);
        diamondInitData[0] = diamondIncrementalHelper.makeInitData("");
        diamondInitData[1] = ownableHelper.makeInitData(abi.encode(users.owner));

        return Diamond.InitParams({
            baseFacets: baseFacets,
            init: MULTI_INIT_ADDRESS,
            initData: abi.encode(diamondInitData)
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
        return diamondIncremental.DiamondIncremental_init.selector;
    }

    function supportedInterfaces() public pure override returns (bytes4[] memory interfaces) {
        interfaces = new bytes4[](1);
        interfaces[0] = type(IDiamondIncremental).interfaceId;
    }
}
