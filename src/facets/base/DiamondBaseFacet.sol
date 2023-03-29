// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamond } from "src/IDiamond.sol";
import { DiamondBaseBehavior, IDiamondBase } from "./DiamondBaseBehavior.sol";

import { DiamondCutBehavior, IDiamondCut } from "./cut/DiamondCutBehavior.sol";
import { DiamondLoupeBehavior, IDiamondLoupe } from "./loupe/DiamondLoupeBehavior.sol";
import { IntrospectionBehavior, IERC165 } from "./introspection/IntrospectionBehavior.sol";
import { OwnableBehavior, IERC173 } from "./ownable/OwnableBehavior.sol";

contract DiamondBaseFacet is IDiamondBase, IDiamondLoupe, IDiamondCut, IERC165, IERC173 {
    function initialize(address deployer) external {
        OwnableBehavior.transferOwnership(deployer);

        IntrospectionBehavior.addInterface(type(IDiamondBase).interfaceId);
        IntrospectionBehavior.addInterface(type(IDiamondLoupe).interfaceId);
        IntrospectionBehavior.addInterface(type(IDiamondCut).interfaceId);
        IntrospectionBehavior.addInterface(type(IERC165).interfaceId);
        IntrospectionBehavior.addInterface(type(IERC173).interfaceId);
    }

    modifier onlyOwner() {
        OwnableBehavior.checkOwner(msg.sender);
        _;
    }

    /// @inheritdoc IDiamondBase
    function immute(bytes4[] calldata selectors) external onlyOwner {
        DiamondBaseBehavior.immute(selectors);
    }

    /// @inheritdoc IDiamondBase
    function isImmutable(bytes4 selector) external view returns (bool) {
        return DiamondBaseBehavior.isImmutable(selector);
    }

    /// @inheritdoc IDiamondBase
    function diamondFactory() external view returns (address) {
        return DiamondBaseBehavior.diamondFactory();
    }

    /// @inheritdoc IDiamondCut
    function diamondCut(
        IDiamond.FacetCut[] calldata facetCuts,
        address init,
        bytes calldata initData
    )
        external
        onlyOwner
    {
        DiamondCutBehavior.diamondCut(facetCuts, init, initData);
    }

    /// @inheritdoc IDiamondLoupe
    function facets() external view returns (Facet[] memory) {
        return DiamondLoupeBehavior.facets();
    }

    /// @inheritdoc IDiamondLoupe
    function facetFunctionSelectors(address facet) external view returns (bytes4[] memory) {
        return DiamondLoupeBehavior.facetSelectors(facet);
    }

    /// @inheritdoc IDiamondLoupe
    function facetAddresses() external view returns (address[] memory) {
        return DiamondLoupeBehavior.facetAddresses();
    }

    /// @inheritdoc IDiamondLoupe
    function facetAddress(bytes4 selector) external view returns (address) {
        return DiamondLoupeBehavior.facetAddress(selector);
    }

    /// @inheritdoc IERC165
    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return IntrospectionBehavior.supportsInterface(interfaceId);
    }

    /// @inheritdoc IERC173
    function owner() external view returns (address) {
        return OwnableBehavior.owner();
    }

    /// @inheritdoc IERC173
    function transferOwnership(address newOwner) external onlyOwner {
        OwnableBehavior.transferOwnership(newOwner);
    }
}
