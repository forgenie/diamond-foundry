// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import { BaseTest } from "test/Base.t.sol";
import { FacetTest, FacetHelper, Diamond } from "test/facets/Facet.t.sol";
import { MockFacetHelper } from "test/mocks/MockFacet.t.sol";
import { IDiamondLoupeBase } from "src/facets/loupe/IDiamondLoupe.sol";
import { DiamondLoupeFacet } from "src/facets/loupe/DiamondLoupeFacet.sol";
import { DiamondCutFacetHelper } from "test/facets/cut/cut.t.sol";
import { OwnableFacetHelper } from "test/facets/ownable/ownable.t.sol";
import { IDiamondLoupe, IERC165 } from "src/facets/loupe/IDiamondLoupe.sol";
import { MULTI_INIT_ADDRESS } from "src/Constants.sol";
import { IDiamondCut } from "src/facets/cut/IDiamondCut.sol";

abstract contract DiamondLoupeFacetTest is IDiamondLoupeBase, FacetTest {
    IDiamondLoupe public diamondLoupe;

    /// @dev shortcut for multiFacetTest
    FacetHelper public facet;
    FacetHelper[] public facets;

    modifier multiFacetTest(FacetHelper[] memory testFacets) {
        for (uint256 i = 0; i < testFacets.length; i++) {
            facet = testFacets[i];
            _;
        }
    }

    modifier appendFacets(FacetHelper[] memory testFacets) {
        delete facets;
        for (uint256 i = 0; i < testFacets.length; i++) {
            facets.push(testFacets[i]);
        }
        _;
    }

    function setUp() public virtual override {
        super.setUp();

        diamondLoupe = IDiamondLoupe(diamond);
    }

    function diamondInitParams() public override returns (Diamond.InitParams memory) {
        DiamondLoupeFacetHelper diamondLoupeHelper = new DiamondLoupeFacetHelper();
        DiamondCutFacetHelper diamondCutHelper = new DiamondCutFacetHelper();
        OwnableFacetHelper ownableHelper = new OwnableFacetHelper();

        FacetCut[] memory baseFacets = new FacetCut[](3);
        baseFacets[0] = diamondLoupeHelper.makeFacetCut(FacetCutAction.Add);
        baseFacets[1] = diamondCutHelper.makeFacetCut(FacetCutAction.Add);
        baseFacets[2] = ownableHelper.makeFacetCut(FacetCutAction.Add);

        MultiInit[] memory diamondInitData = new MultiInit[](3);
        diamondInitData[0] = diamondLoupeHelper.makeInitData("");
        diamondInitData[1] = diamondCutHelper.makeInitData("");
        diamondInitData[2] = ownableHelper.makeInitData(abi.encode(users.owner));

        return Diamond.InitParams({
            baseFacets: baseFacets,
            init: MULTI_INIT_ADDRESS,
            initData: abi.encode(diamondInitData)
        });
    }

    function mockFacet() internal returns (FacetHelper[] memory) {
        delete facets;
        facets.push(new MockFacetHelper());
        return facets;
    }

    function addFacet(FacetHelper testFacet) internal {
        FacetCut[] memory facetCuts = new FacetCut[](1);
        facetCuts[0] = testFacet.makeFacetCut(FacetCutAction.Add);

        IDiamondCut(diamond).diamondCut(facetCuts, address(0), "");
    }

    function removeFacet(FacetHelper testFacet) internal {
        FacetCut[] memory facetCuts = new FacetCut[](1);
        facetCuts[0] = testFacet.makeFacetCut(FacetCutAction.Remove);

        IDiamondCut(diamond).diamondCut(facetCuts, address(0), "");
    }

    /// @dev Here testFacet should be the new facet address.
    function replaceFacet(FacetHelper testFacet) internal {
        FacetCut[] memory facetCuts = new FacetCut[](1);
        facetCuts[0] = testFacet.makeFacetCut(FacetCutAction.Replace);

        IDiamondCut(diamond).diamondCut(facetCuts, address(0), "");
    }
}

contract DiamondLoupeFacetHelper is FacetHelper {
    DiamondLoupeFacet public diamondLoupe;

    constructor() {
        diamondLoupe = new DiamondLoupeFacet();
    }

    function facet() public view override returns (address) {
        return address(diamondLoupe);
    }

    function selectors() public view override returns (bytes4[] memory selectors_) {
        selectors_ = new bytes4[](5);
        selectors_[0] = diamondLoupe.facetFunctionSelectors.selector;
        selectors_[1] = diamondLoupe.facetAddresses.selector;
        selectors_[2] = diamondLoupe.facetAddress.selector;
        selectors_[3] = diamondLoupe.facets.selector;
        selectors_[4] = diamondLoupe.supportsInterface.selector;
    }

    function initializer() public view override returns (bytes4) {
        return diamondLoupe.DiamondLoupe_init.selector;
    }

    function supportedInterfaces() public pure override returns (bytes4[] memory interfaces_) {
        interfaces_ = new bytes4[](2);
        interfaces_[0] = type(IDiamondLoupe).interfaceId;
        interfaces_[1] = type(IERC165).interfaceId;
    }

    function creationCode() public pure override returns (bytes memory) {
        return type(DiamondLoupeFacet).creationCode;
    }
}
