// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { IDiamondFactory, IFacetRegistry, IDiamond } from "./IDiamondFactory.sol";

contract DiamondFactory is IDiamondFactory {
    function createDiamond(bytes32[] calldata baseFacetIds) external returns (address diamondAddr) { }

    /// @inheritdoc IDiamondFactory
    function createDiamond(bytes32[] calldata baseFacetIds, uint256 salt) external returns (address diamondAddr) { }

    /// @inheritdoc IDiamondFactory
    function facetRegistry() external view returns (IFacetRegistry) { }

    function makeFacetCut(
        IDiamond.FacetCutAction action,
        bytes32 facetId
    )
        external
        view
        override
        returns (IDiamond.FacetCut memory facetCut)
    { }
}
