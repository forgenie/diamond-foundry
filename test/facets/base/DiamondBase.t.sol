// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IDiamond } from "src/IDiamond.sol";

import { DiamondBaseFacet } from "src/facets/base/DiamondBaseFacet.sol";
import { FacetTest } from "../Facet.t.sol";
import { FacetHelper } from "../FacetHelper.t.sol";

abstract contract DiamondBaseFacetTest is FacetTest {
    DiamondBaseFacetHelper public diamondBaseHelper;

    address[] internal _facets;
    IDiamond.FacetCut[] internal _facetCuts;
    bytes4[] internal _selectors;

    function setUp() public virtual override {
        // Adding to facets helpers before calling super
        diamondBaseHelper = new DiamondBaseFacetHelper();
        facets.push(diamondBaseHelper);

        // super will create a diamond with this facet
        super.setUp();
    }
}

contract DiamondBaseFacetHelper is FacetHelper {
    DiamondBaseFacet internal diamondBaseFacet;

    constructor() {
        diamondBaseFacet = new DiamondBaseFacet();
    }

    function facet() public override returns (address) {
        return address(diamondBaseFacet);
    }

    function selectors() public pure override returns (bytes4[] memory selectors_) {
        selectors_ = new bytes4[](11);
        selectors_[0] = DiamondBaseFacet.immute.selector;
        selectors_[1] = DiamondBaseFacet.isImmutable.selector;
        selectors_[2] = DiamondBaseFacet.diamondFactory.selector;
        selectors_[3] = DiamondBaseFacet.diamondCut.selector;
        selectors_[4] = DiamondBaseFacet.facets.selector;
        selectors_[5] = DiamondBaseFacet.facetFunctionSelectors.selector;
        selectors_[6] = DiamondBaseFacet.facetAddresses.selector;
        selectors_[7] = DiamondBaseFacet.facetAddress.selector;
        selectors_[8] = DiamondBaseFacet.supportsInterface.selector;
        selectors_[9] = DiamondBaseFacet.owner.selector;
        selectors_[10] = DiamondBaseFacet.transferOwnership.selector;
    }

    function initializer() public pure override returns (bytes4) {
        return DiamondBaseFacet.initialize.selector;
    }

    function name() public pure override returns (string memory) {
        return "DiamondBase";
    }
}
