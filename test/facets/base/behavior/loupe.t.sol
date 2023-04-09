// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IDiamondLoupe } from "src/facets/base/loupe/IDiamondLoupe.sol";

import { DiamondBaseFacetTest, FacetHelper } from "test/facets/base/DiamondBase.t.sol";

contract DiamondLoupeTest is DiamondBaseFacetTest {
    IDiamondLoupe public diamondLoupe;

    function setUp() public override {
        super.setUp();

        diamondLoupe = IDiamondLoupe(diamond);
    }

    function test_facetAddresses() public {
        address[] memory facetAddresses = diamondLoupe.facetAddresses();
        assertEq(facetAddresses.length, facets.length);

        for (uint256 i = 0; i < facetAddresses.length; i++) {
            address expectedFacetAddress = facets[i].facet();

            assertEq(facetAddresses[i], expectedFacetAddress);
        }
    }

    function test_facetAddress() public {
        address[] memory facetAddresses = diamondLoupe.facetAddresses();
        assertEq(facetAddresses.length, facets.length);

        for (uint256 i = 0; i < facetAddresses.length; i++) {
            bytes4[] memory selectors = facets[i].selectors();

            for (uint256 j = 0; j < selectors.length; j++) {
                assertEq(diamondLoupe.facetAddress(selectors[j]), facets[i].facet());
            }
        }
    }

    function test_facetFunctionSelectors() public {
        address[] memory facetAddresses = diamondLoupe.facetAddresses();
        assertEq(facetAddresses.length, facets.length);

        for (uint256 i = 0; i < facetAddresses.length; i++) {
            bytes4[] memory expectedSelectors = facets[i].selectors();
            bytes4[] memory selectors = diamondLoupe.facetFunctionSelectors(facets[i].facet());

            assertEq(expectedSelectors.length, selectors.length);
            for (uint256 j = 0; j < selectors.length; j++) {
                assertEq(expectedSelectors[j], selectors[j]);
            }
        }
    }

    function test_facets() public {
        address[] memory facetAddresses = diamondLoupe.facetAddresses();
        assertEq(facetAddresses.length, facets.length);

        IDiamondLoupe.Facet[] memory expectedFacets = diamondLoupe.facets();

        assertEq(expectedFacets.length, facets.length);
        for (uint256 i = 0; i < expectedFacets.length; i++) {
            assertEq(expectedFacets[i].facetAddress, facets[i].facet());

            bytes4[] memory selectors = facets[i].selectors();
            bytes4[] memory expectedSelectors = expectedFacets[i].functionSelectors;

            assertEq(expectedSelectors.length, selectors.length);
            for (uint256 j = 0; j < selectors.length; j++) {
                assertEq(expectedSelectors[j], selectors[j]);
            }
        }
    }
}
