// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { Diamond } from "../Diamond.sol";
import { IDiamondFactory, IFacetRegistry, IDiamond } from "./IDiamondFactory.sol";

error DiamondFactory_multiCall_InvalidLength();
error DiamondFactory_deployDiamond_InvalidInitializer();

contract DiamondFactory is IDiamondFactory {
    struct BaseFacet {
        bytes32 facetId;
        bytes initData;
    }

    IFacetRegistry private immutable _facetRegistry;

    address[] private _baseFacets;
    bytes[] private _baseFacetsInitData;

    constructor(IFacetRegistry registry) {
        _facetRegistry = registry;
    }

    /// @inheritdoc IDiamondFactory
    function createDiamond(bytes32 baseFacetId) external returns (address diamond) {
        diamond = _deployDiamondBase(baseFacetId, msg.sender);

        // slither-disable-next-line reentrancy-events
        emit DiamondCreated(diamond, msg.sender, baseFacetId);
    }

    function createDiamond(BaseFacet[] calldata baseFacets) external returns (address diamond) {
        diamond = _deployDiamond(baseFacets);

        // emit
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

    function multiCall() external {
        // onltDelegateCalls();
        uint256 baseFacetCount = _baseFacets.length;
        for (uint256 i = 0; i < baseFacetCount; i++) {
            Address.functionDelegateCall(_baseFacets[i], _baseFacetsInitData[i]);
        }
    }

    function _deployDiamond(BaseFacet[] calldata baseFacets) internal returns (address diamond) {
        uint256 facetCount = baseFacets.length;

        IDiamond.FacetCut[] memory facetCuts = new IDiamond.FacetCut[](facetCount);
        for (uint256 i = 0; i < facetCount; i++) {
            BaseFacet memory facet = baseFacets[i];

            address facetAddr = _facetRegistry.getFacetAddress(facet.facetId);
            facetCuts[i] = IDiamond.FacetCut({
                action: IDiamond.FacetCutAction.Add,
                facet: facetAddr,
                selectors: _facetRegistry.getFacetSelectors(facet.facetId)
            });

            bytes4 initializer = _facetRegistry.getInitializer(facet.facetId);
            if (initializer != bytes4(0)) {
                _baseFacets.push(facetAddr);
                _baseFacetsInitData.push(facet.initData);
            }
        }

        Diamond.InitParams memory initParams = Diamond.InitParams({
            baseFacets: facetCuts,
            init: address(this),
            initData: abi.encodeWithSelector(this.multiCall.selector)
        });

        diamond = address(new Diamond(initParams));

        delete _baseFacets;
        delete _baseFacetsInitData;
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
