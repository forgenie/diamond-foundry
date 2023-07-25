// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { BaseTest } from "test/Base.t.sol";
import { FacetHelper } from "test/facets/Facet.t.sol";
import { MockFacetHelper } from "test/mocks/MockFacet.sol";
import { DiamondLoupeBase } from "src/facets/loupe/DiamondLoupeBase.sol";
import { DiamondCutBase } from "src/facets/cut/DiamondCutBase.sol";
import { DiamondLoupeFacet } from "src/facets/loupe/DiamondLoupeFacet.sol";
import { IDiamondLoupe, IERC165 } from "src/facets/loupe/IDiamondLoupe.sol";

abstract contract DiamondLoupeBaseTest is DiamondLoupeBase, DiamondCutBase, BaseTest {
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

        // todo: set up diamond
    }

    function mockFacet() internal returns (FacetHelper[] memory) {
        delete facets;
        facets.push(new MockFacetHelper());
        return facets;
    }

    // todo: write helper function addFacet
    // todo: write helper function removeFacet
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
