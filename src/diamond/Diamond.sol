// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { Proxy } from "@openzeppelin/contracts/proxy/Proxy.sol";
import { Auth, IOwned } from "src/auth/Auth.sol";
import { DiamondBase } from "./DiamondBase.sol";
import { DiamondCutBehavior } from "src/facets/cut/DiamondCutBehavior.sol";
import { IDiamond, IDiamondCut, IDiamondLoupe, IERC165 } from "./IDiamond.sol";

error Diamond_UnsupportedFunction();
error Diamond_NoOwnableFacetProvided();

contract Diamond is IDiamond, Proxy, DiamondBase, Auth {
    struct InitParams {
        FacetCut[] baseFacets;
        address init;
        bytes initData;
    }

    constructor() {
        _disableInitializers();
    }

    function initialize(InitParams calldata initDiamondCut) external initializer {
        __DiamondLoupe_init();
        __Introspection_init();
        __DiamondCut_init();

        // Register immutable functiions.
        bytes4[] memory selectors = new bytes4[](6);
        selectors[0] = this.diamondCut.selector;
        selectors[1] = this.facets.selector;
        selectors[2] = this.facetAddresses.selector;
        selectors[3] = this.facetFunctionSelectors.selector;
        selectors[4] = this.facetAddress.selector;
        selectors[5] = this.supportsInterface.selector;
        DiamondCutBehavior.addFacet(address(this), selectors);

        _diamondCut(initDiamondCut.baseFacets, initDiamondCut.init, initDiamondCut.initData);
    }

    /// @inheritdoc IDiamondCut
    function diamondCut(FacetCut[] memory cuts, address init, bytes memory data) external onlyOwner {
        _diamondCut(cuts, init, data);
    }

    /// @inheritdoc IDiamondLoupe
    function facets() external view returns (Facet[] memory) {
        return _facets();
    }

    /// @inheritdoc IDiamondLoupe
    function facetAddresses() external view returns (address[] memory) {
        return _facetAddresses();
    }

    /// @inheritdoc IDiamondLoupe
    function facetFunctionSelectors(address facet) external view returns (bytes4[] memory) {
        return _facetSelectors(facet);
    }

    /// @inheritdoc IDiamondLoupe
    function facetAddress(bytes4 selector) external view returns (address) {
        return _facetAddress(selector);
    }

    /// @inheritdoc IERC165
    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return _supportsInterface(interfaceId);
    }

    function _diamondDelegate(bytes4 selector, bytes calldata data) internal {
        address facet = _facetAddress(selector);

        if (facet == address(0)) revert Diamond_UnsupportedFunction();

        // slither-disable-next-line unused-return
        Address.functionDelegateCall(facet, data);

        // solhint-disable-next-line no-inline-assembly
        assembly {
            // get return value
            returndatacopy(0, 0, returndatasize())
            // return return value or error back to the caller
            return(0, returndatasize())
        }
    }

    function _fallback() internal override {
        _diamondDelegate(msg.sig, msg.data);
    }

    // solhint-disable-next-line no-empty-blocks
    function _implementation() internal view override returns (address) { }
}
