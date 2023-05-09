// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IDiamond } from "src/Diamond.sol";

import { IFacetRegistry } from "src/registry/IFacetRegistry.sol";

abstract contract FacetHelper {
    function facet() public view virtual returns (address);

    function selectors() public view virtual returns (bytes4[] memory);

    function initializer() public view virtual returns (bytes4);

    function name() public view virtual returns (string memory);

    function supportedInterfaces() public view virtual returns (bytes4[] memory);

    function facetInfo() public view returns (IFacetRegistry.FacetInfo memory info) {
        info = IFacetRegistry.FacetInfo({
            name: name(),
            addr: facet(),
            initializer: initializer(),
            selectors: selectors()
        });
    }

    function makeFacetCut(IDiamond.FacetCutAction action) public view returns (IDiamond.FacetCut memory) {
        return IDiamond.FacetCut({ action: action, facet: facet(), selectors: selectors() });
    }
}
