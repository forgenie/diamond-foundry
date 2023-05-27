// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { Create2 } from "@openzeppelin/contracts/utils/Create2.sol";
import { BeaconProxy } from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import { ERC721A } from "@erc721a/ERC721A.sol";
import { DiamondBase } from "../DiamondBase.sol";
import { DiamondBeaconProxy } from "../DiamondBeaconProxy.sol";
import { DelegateCall } from "src/utils/DelegateCall.sol";
import { IDiamondFoundry, IFacetRegistry, IBeacon, IDiamond } from "./IDiamondFoundry.sol";
import { Diamond } from "../Diamond.sol";

contract DiamondFoundry is IDiamondFoundry, ERC721A, DelegateCall {
    IFacetRegistry private immutable _facetRegistry;
    address private immutable _diamondImplementation;

    mapping(uint256 tokenId => address proxy) private _diamonds;
    mapping(address proxy => uint256 tokenId) private _tokenIds;

    event DiamondImplementationChanged(address indexed previousDiamond, address indexed newDiamond);

    constructor(IFacetRegistry registry, address diamondImplementation) ERC721A("Diamond Foundry", "FOUNDRY") {
        _facetRegistry = registry;
        _diamondImplementation = diamondImplementation;

        // zero'th token is used as a sentinel value
        _mint(address(this), 1);

        emit DiamondImplementationChanged(address(0), diamondImplementation);
    }

    /// @inheritdoc IDiamondFoundry
    function mintDiamond() external returns (address diamond) {
        uint256 tokenId = _nextTokenId();
        bytes32 salt = keccak256(abi.encode(tokenId, msg.sender));

        bytes memory initData = abi.encodeWithSelector(DiamondBase.initialize.selector, msg.sender);
        diamond = address(new DiamondBeaconProxy{ salt: salt }(initData));

        _diamonds[tokenId] = diamond;
        _tokenIds[diamond] = tokenId;

        _mint(msg.sender, 1);

        emit DiamondMinted(tokenId, diamond);
    }

    function diamondAddress(uint256 tokenId) external view returns (address) {
        return _diamonds[tokenId];
    }

    function tokenIdOf(address diamond) external view returns (uint256) {
        return _tokenIds[diamond];
    }

    // todo: move this into diamond
    /// @inheritdoc IDiamondFoundry
    function multiDelegateCall(FacetInit[] memory diamondInitData) external onlyDelegateCall {
        for (uint256 i = 0; i < diamondInitData.length; i++) {
            FacetInit memory facetInit = diamondInitData[i];
            if (facetInit.data.length == 0) continue;

            // slither-disable-next-line unused-return
            Address.functionDelegateCall(facetInit.facet, facetInit.data);
        }
    }

    /// @inheritdoc IDiamondFoundry
    function facetRegistry() external view returns (IFacetRegistry) {
        return _facetRegistry;
    }

    /// @inheritdoc IBeacon
    function implementation() external view override returns (address) {
        return _diamondImplementation;
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
