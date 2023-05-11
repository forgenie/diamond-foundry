// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { Diamond } from "../Diamond.sol";
import { IDiamondFactory, IFacetRegistry, IDiamond } from "./IDiamondFactory.sol";
import { DelegateCall } from "src/utils/DelegateCall.sol";

contract DiamondFactory is IDiamondFactory, DelegateCall {
    IFacetRegistry private immutable _facetRegistry;

    constructor(IFacetRegistry registry) {
        _facetRegistry = registry;
    }

    /// @inheritdoc IDiamondFactory
    function createDiamond(BaseFacet[] calldata baseFacets) external returns (address diamond) {
        diamond = _deployDiamond(baseFacets);

        // slither-disable-next-line reentrancy-events
        emit DiamondCreated(diamond, msg.sender, baseFacets);
    }

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

    /// @inheritdoc IDiamondFactory
    function multiDelegateCall(FacetInit[] memory diamondInitData) external onlyDelegateCall {
        for (uint256 i = 0; i < diamondInitData.length; i++) {
            FacetInit memory facetInit = diamondInitData[i];
            if (facetInit.data.length == 0) continue;

            // slither-disable-next-line unused-return
            Address.functionDelegateCall(facetInit.facet, facetInit.data);
        }
    }

    function _deployDiamond(BaseFacet[] calldata baseFacets) internal returns (address diamond) {
        // todo: revise
        IDiamond.FacetCut[] memory facetCuts = new IDiamond.FacetCut[](baseFacets.length);
        FacetInit[] memory diamondInitData = new FacetInit[](baseFacets.length);

        for (uint256 i = 0; i < baseFacets.length; i++) {
            BaseFacet memory facet = baseFacets[i];

            address facetAddr = _facetRegistry.getFacetAddress(facet.facetId);
            facetCuts[i] = IDiamond.FacetCut({
                action: IDiamond.FacetCutAction.Add,
                facet: facetAddr,
                selectors: _facetRegistry.getFacetSelectors(facet.facetId)
            });

            bytes4 initializer = _facetRegistry.getInitializer(facet.facetId);

            if (initializer != bytes4(0)) {
                diamondInitData[i] =
                    FacetInit({ facet: facetAddr, data: abi.encodeWithSelector(initializer, facet.initArgs) });
            }
        }

        Diamond.InitParams memory initParams = Diamond.InitParams({
            baseFacets: facetCuts,
            init: address(this),
            initData: abi.encodeWithSelector(this.multiDelegateCall.selector, diamondInitData)
        });

        diamond = address(new Diamond(initParams));
    }
}
