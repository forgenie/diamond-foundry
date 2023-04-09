// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IDiamond, Diamond } from "src/Diamond.sol";

import { DiamondBaseFacet } from "src/facets/base/DiamondBaseFacet.sol";
import { FacetTest, FacetHelper } from "../Facet.t.sol";

abstract contract DiamondBaseFacetTest is FacetTest {
    DiamondBaseFacetHelper public diamondBaseHelper;

    function setUp() public virtual override {
        diamondBaseHelper = new DiamondBaseFacetHelper();
        facets.push(diamondBaseHelper);

        super.setUp();
    }

    function diamondInitParams() internal virtual override returns (Diamond.InitParams memory) {
        address init = diamondBaseHelper.facet();
        bytes memory initData = abi.encodeWithSelector(diamondBaseHelper.initializer(), users.owner);

        IDiamond.FacetCut[] memory baseFacets = new IDiamond.FacetCut[](1);
        baseFacets[0] = diamondBaseHelper.makeFacetCut(IDiamond.FacetCutAction.Add);

        return Diamond.InitParams({ baseFacets: baseFacets, init: init, initData: initData });
    }
}

contract DiamondBaseFacetHelper is FacetHelper {
    DiamondBaseFacet internal diamondBaseFacet;

    constructor() {
        diamondBaseFacet = new DiamondBaseFacet();
    }

    function facet() public view override returns (address) {
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
