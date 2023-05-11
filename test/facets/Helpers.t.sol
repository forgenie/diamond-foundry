// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { IDiamond } from "src/Diamond.sol";
import { IDiamondFactoryStructs } from "src/factory/IDiamondFactory.sol";
import { IFacetRegistry } from "src/registry/IFacetRegistry.sol";

abstract contract FacetHelper is IDiamondFactoryStructs {
    function facet() public view virtual returns (address);

    function selectors() public view virtual returns (bytes4[] memory);

    function initializer() public view virtual returns (bytes4);

    function name() public pure virtual returns (string memory);

    function supportedInterfaces() public pure virtual returns (bytes4[] memory);

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

    function makeInitData(bytes memory) public view virtual returns (FacetInit memory) {
        // Initializers accepting arguments can override this function
        // and decode the arguments here.
        return FacetInit({ facet: facet(), data: abi.encodeWithSelector(initializer()) });
    }

    function multiDelegateCall(FacetInit[] memory diamondInitData) external {
        for (uint256 i = 0; i < diamondInitData.length; i++) {
            FacetInit memory facetInit = diamondInitData[i];

            Address.functionDelegateCall(facetInit.facet, facetInit.data);
        }
    }
}
