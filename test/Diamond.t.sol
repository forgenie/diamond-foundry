// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { FacetHelper } from "test/facets/Facet.t.sol";
import { IERC165, IDiamondLoupe } from "src/facets/loupe/IDiamondLoupe.sol";

// todo: refactor into invariant test
abstract contract DiamondContext is PRBTest {
    address public diamond;
    FacetHelper[] public facets;

    function test_facetAddresses() public {
        address[] memory facetAddresses = IDiamondLoupe(diamond).facetAddresses();
        assertEq(facetAddresses.length, facets.length);

        for (uint256 i = 0; i < facetAddresses.length; i++) {
            address expectedFacetAddress = facets[i].facet();

            assertEq(facetAddresses[i], expectedFacetAddress);
        }
    }

    function test_facetAddress() public {
        address[] memory facetAddresses = IDiamondLoupe(diamond).facetAddresses();
        assertEq(facetAddresses.length, facets.length);

        for (uint256 i = 0; i < facetAddresses.length; i++) {
            bytes4[] memory selectors = facets[i].selectors();

            for (uint256 j = 0; j < selectors.length; j++) {
                assertEq(IDiamondLoupe(diamond).facetAddress(selectors[j]), facets[i].facet());
            }
        }
    }

    function test_facetFunctionSelectors() public {
        address[] memory facetAddresses = IDiamondLoupe(diamond).facetAddresses();
        assertEq(facetAddresses.length, facets.length);

        for (uint256 i = 0; i < facetAddresses.length; i++) {
            bytes4[] memory expectedSelectors = facets[i].selectors();
            bytes4[] memory selectors = IDiamondLoupe(diamond).facetFunctionSelectors(facets[i].facet());

            assertEq(expectedSelectors.length, selectors.length);
            for (uint256 j = 0; j < selectors.length; j++) {
                assertEq(expectedSelectors[j], selectors[j]);
            }
        }
    }

    function test_facets() public {
        address[] memory facetAddresses = IDiamondLoupe(diamond).facetAddresses();
        assertEq(facetAddresses.length, facets.length);

        IDiamondLoupe.Facet[] memory expectedAddresses = IDiamondLoupe(diamond).facets();

        assertEq(expectedAddresses.length, facets.length);
        for (uint256 i = 0; i < expectedAddresses.length; i++) {
            assertEq(expectedAddresses[i].facet, facets[i].facet());

            bytes4[] memory selectors = facets[i].selectors();
            bytes4[] memory expectedSelectors = expectedAddresses[i].selectors;

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
                assertEq(IERC165(diamond).supportsInterface(supportedInterfaces[j]), true);
            }
        }
    }
}
