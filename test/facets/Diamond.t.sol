// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { BaseTest } from "test/Base.t.sol";
import { FacetHelper } from "./Helpers.t.sol";
import { IDiamondLoupe } from "src/facets/loupe/IDiamondLoupe.sol";
import { IERC165 } from "src/facets/introspection/IERC165.sol";

abstract contract DiamondContext is BaseTest {
    address public diamond;
    FacetHelper[] public facets;
    IDiamondLoupe public diamondLoupe;
    IERC165 public introspection;

    function setUp() public virtual override {
        // note: here we don't call super

        diamondLoupe = IDiamondLoupe(diamond);
        introspection = IERC165(diamond);
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

    function test_supportsInterfaces() public {
        for (uint256 i = 0; i < facets.length; i++) {
            bytes4[] memory supportedInterfaces = facets[i].supportedInterfaces();

            for (uint256 j = 0; j < supportedInterfaces.length; j++) {
                assertEq(introspection.supportsInterface(supportedInterfaces[j]), true);
            }
        }
    }
}
