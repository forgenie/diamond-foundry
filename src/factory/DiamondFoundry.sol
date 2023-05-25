// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { Create2 } from "@openzeppelin/contracts/utils/Create2.sol";
import { ERC721A } from "@erc721a/ERC721A.sol";

import { DelegateCall } from "src/utils/DelegateCall.sol";
import { IDiamondFoundry, IFacetRegistry, IDiamond } from "./IDiamondFoundry.sol";
import { Diamond } from "../Diamond.sol";

contract DiamondFoundry is IDiamondFoundry, ERC721A, DelegateCall {
    IFacetRegistry private immutable _facetRegistry;

    address private _diamondImplementation;

    constructor(IFacetRegistry registry, address diamondImplementation) ERC721A("Diamond Foundry", "FOUNDRY") {
        _facetRegistry = registry;

        _diamondImplementation = diamondImplementation;
    }

    /// @inheritdoc IDiamondFoundry
    function mintDiamond(BaseFacet[] calldata baseFacets) external returns (address diamond) {
        diamond = _deployDiamond(baseFacets);

        // slither-disable-next-line reentrancy-events
        emit DiamondCreated(diamond, msg.sender, baseFacets);
    }

    /// @inheritdoc IDiamondFoundry
    function facetRegistry() external view returns (IFacetRegistry) {
        return _facetRegistry;
    }

    /// @inheritdoc IDiamondFoundry
    function makeFacetCut(
        IDiamond.FacetCutAction action,
        bytes32 facetId
    )
        public
        view
        returns (IDiamond.FacetCut memory facetCut)
    {
        facetCut.action = action;
        facetCut.facet = _facetRegistry.facetAddress(facetId);
        facetCut.selectors = _facetRegistry.facetSelectors(facetId);
    }

    /// @inheritdoc IDiamondFoundry
    function multiDelegateCall(FacetInit[] memory diamondInitData) external onlyDelegateCall {
        for (uint256 i = 0; i < diamondInitData.length; i++) {
            FacetInit memory facetInit = diamondInitData[i];
            if (facetInit.data.length == 0) continue;

            // slither-disable-next-line unused-return
            Address.functionDelegateCall(facetInit.facet, facetInit.data);
        }
    }

    function _deployDiamond(BaseFacet[] calldata baseFacets) internal returns (address diamond) {
        uint256 facetCount = baseFacets.length; // gas savings
        IDiamond.FacetCut[] memory facetCuts = new IDiamond.FacetCut[](facetCount);
        FacetInit[] memory diamondInitData = new FacetInit[](facetCount);
        for (uint256 i = 0; i < facetCount; i++) {
            BaseFacet memory facet = baseFacets[i];

            address facetAddr = _facetRegistry.facetAddress(facet.facetId);
            facetCuts[i] = IDiamond.FacetCut({
                action: IDiamond.FacetCutAction.Add,
                facet: facetAddr,
                selectors: _facetRegistry.facetSelectors(facet.facetId)
            });

            bytes4 initializer = _facetRegistry.initializer(facet.facetId);
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
