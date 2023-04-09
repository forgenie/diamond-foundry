// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Diamond } from "../Diamond.sol";
import { IDiamondFactory, IFacetRegistry, IDiamond } from "./IDiamondFactory.sol";

contract DiamondFactory is IDiamondFactory {
    /// @custom:security non-reentrant
    IFacetRegistry private immutable _facetRegistry;

    constructor(IFacetRegistry registry) {
        _facetRegistry = registry;
    }

    /// @inheritdoc IDiamondFactory
    function createDiamond(bytes32 baseFacetId) external returns (address diamond) {
        diamond = _deployDiamondBase(baseFacetId, msg.sender);

        // slither-disable-next-line reentrancy-events
        emit DiamondCreated(diamond, msg.sender, baseFacetId);
    }

    /// @inheritdoc IDiamondFactory
    // function createDiamond(bytes32[] calldata baseFacetIds, uint256 salt) external returns (address) { }

    /// @inheritdoc IDiamondFactory
    function facetRegistry() external view returns (IFacetRegistry) {
        return _facetRegistry;
    }

    /// @inheritdoc IDiamondFactory
    function makeFacetCut(
        IDiamond.FacetCutAction action,
        bytes32 facetId
    )
        public
        view
        returns (IDiamond.FacetCut memory facetCut)
    {
        facetCut.action = action;
        facetCut.facet = _facetRegistry.getFacetAddress(facetId);
        facetCut.selectors = _facetRegistry.getFacetSelectors(facetId);
    }

    function _deployDiamondBase(bytes32 baseFacetId, address owner) private returns (address) {
        IDiamond.FacetCut[] memory facetCuts = new IDiamond.FacetCut[](1);
        facetCuts[0] = makeFacetCut(IDiamond.FacetCutAction.Add, baseFacetId);

        bytes4 initializer = _facetRegistry.getInitializer(baseFacetId);

        address init;
        bytes memory initData;
        if (initializer == bytes4(0)) {
            init = address(0);
            initData = bytes("");
        } else {
            init = _facetRegistry.getFacetAddress(baseFacetId);
            initData = abi.encodeWithSelector(initializer, owner);
        }

        Diamond.InitParams memory initParams =
            Diamond.InitParams({ baseFacets: facetCuts, init: init, initData: initData });

        return address(new Diamond(initParams));
    }
}
