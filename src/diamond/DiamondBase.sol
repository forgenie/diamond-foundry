// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { Proxy } from "@openzeppelin/contracts/proxy/Proxy.sol";
import { IDiamondFoundry } from "src/IDiamondFoundry.sol";
import { Initializable } from "src/utils/Initializable.sol";
import { DiamondCutBase } from "src/facets/cut/DiamondCutBase.sol";
import { DiamondLoupeBase } from "src/facets/loupe/DiamondLoupeBase.sol";
import { IntrospectionBase } from "src/facets/introspection/IntrospectionBase.sol";
import { OwnableBase } from "src/facets/ownable/OwnableBase.sol";
import { DiamondCutBehavior } from "src/facets/cut/DiamondCutBehavior.sol";
import { IDiamondBase } from "./IDiamondBase.sol";

error DiamondBase_Fallback_UnsupportedFunction();
error DiamondBase_Fallback_CallerIsNotDiamond();

contract DiamondBase is
    IDiamondBase,
    Proxy,
    Initializable,
    DiamondCutBase,
    DiamondLoupeBase,
    IntrospectionBase,
    OwnableBase
{
    IDiamondFoundry public immutable diamondFoundry;

    constructor(IDiamondFoundry foundry) {
        diamondFoundry = foundry;

        _disableInitializers();
    }

    modifier tokenBound() {
        if (diamondFoundry.tokenIdOf(address(this)) == 0) revert DiamondBase_Fallback_CallerIsNotDiamond();
        _;
    }

    function initialize() external initializer {
        __DiamondLoupe_init();
        __Introspection_init();
        __DiamondCut_init();

        bytes4[] memory selectors = new bytes4[](8);
        selectors[0] = this.diamondFoundry.selector;
        selectors[1] = this.diamondCut.selector;
        selectors[2] = this.facets.selector;
        selectors[3] = this.facetAddresses.selector;
        selectors[4] = this.facetFunctionSelectors.selector;
        selectors[5] = this.facetAddress.selector;
        selectors[6] = this.supportsInterface.selector;
        selectors[7] = this.owner.selector;

        DiamondCutBehavior.addFacet(address(this), selectors);
    }

    function diamondCut(FacetCut[] memory cuts, address init, bytes memory data) external tokenBound onlyOwner {
        _diamondCut(cuts, init, data);
    }

    function facets() external view tokenBound returns (Facet[] memory) {
        return _facets();
    }

    function facetAddresses() external view tokenBound returns (address[] memory) {
        return _facetAddresses();
    }

    function facetFunctionSelectors(address facet) external view tokenBound returns (bytes4[] memory) {
        return _facetSelectors(facet);
    }

    function facetAddress(bytes4 selector) external view tokenBound returns (address) {
        return _facetAddress(selector);
    }

    function supportsInterface(bytes4 interfaceId) external view tokenBound returns (bool) {
        return _supportsInterface(interfaceId);
    }

    function owner() external view tokenBound returns (address) {
        return diamondFoundry.ownerOf(diamondFoundry.tokenIdOf(address(this)));
    }

    function _diamondDelegate(bytes4 selector, bytes calldata data) internal {
        address facet = _facetAddress(selector);

        if (facet == address(0)) revert DiamondBase_Fallback_UnsupportedFunction();

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

    function _fallback() internal override tokenBound {
        _diamondDelegate(msg.sig, msg.data);
    }

    // solhint-disable-next-line no-empty-blocks
    function _implementation() internal view override returns (address) { }
}
