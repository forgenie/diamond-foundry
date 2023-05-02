// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { Diamond } from "../Diamond.sol";
import { IDiamondFactory, IFacetRegistry, IDiamond, BaseFacetInfo, FacetInit } from "./IDiamondFactory.sol";
import { console } from "forge-std/console.sol";

error DiamondFactory_multiCall_InvalidLength();
error DiamondFactory_deployDiamond_InvalidInitializer();

contract DiamondFactory is IDiamondFactory {
    IFacetRegistry private immutable _facetRegistry;

    constructor(IFacetRegistry registry) {
        _facetRegistry = registry;
    }

    /// @inheritdoc IDiamondFactory
    function createDiamond(BaseFacetInfo[] calldata baseFacets) external returns (address diamond) {
        diamond = _deployDiamond(baseFacets);

        // slither-disable-next-line reentrancy-events
        emit DiamondCreated(diamond, msg.sender, baseFacets);
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

    // onlyDelegateCalls();
    function multiDelegateCall(FacetInit[] memory diamondInitData) external {
        for (uint256 i = 0; i < diamondInitData.length; i++) {
            FacetInit memory facetInit = diamondInitData[i];
            if (facetInit.data.length == 0) continue;

            Address.functionDelegateCall(facetInit.facet, facetInit.data);
        }
    }

    function _deployDiamond(BaseFacetInfo[] calldata baseFacets) internal returns (address diamond) {
        IDiamond.FacetCut[] memory facetCuts = new IDiamond.FacetCut[](baseFacets.length);
        FacetInit[] memory diamondInitData = new FacetInit[](baseFacets.length);

        for (uint256 i = 0; i < baseFacets.length; i++) {
            BaseFacetInfo memory facet = baseFacets[i];

            address facetAddr = _facetRegistry.getFacetAddress(facet.facetId);
            facetCuts[i] = IDiamond.FacetCut({
                action: IDiamond.FacetCutAction.Add,
                facet: facetAddr,
                selectors: _facetRegistry.getFacetSelectors(facet.facetId)
            });

            bytes4 initializer = _facetRegistry.getInitializer(facet.facetId);

            if (initializer != bytes4(0)) {
                diamondInitData[i] =
                    FacetInit({ facet: facetAddr, data: abi.encodeWithSelector(initializer, facet.initData) });
            }
        }

        Diamond.InitParams memory initParams = Diamond.InitParams({
            baseFacets: facetCuts,
            init: address(this),
            initData: abi.encodeWithSelector(this.multiDelegateCall.selector, diamondInitData)
        });

        diamond = address(new Diamond(initParams));
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
