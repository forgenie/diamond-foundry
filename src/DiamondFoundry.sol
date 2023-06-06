// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { BeaconProxy } from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import { ERC721A } from "@erc721a/ERC721A.sol";
import { DiamondBase } from "src/diamond/DiamondBase.sol";
import { DiamondBeaconProxy } from "src/diamond/DiamondBeaconProxy.sol";
import { IDiamondFoundry, IFacetRegistry, IBeacon, IDiamond } from "./IDiamondFoundry.sol";

contract DiamondFoundry is IDiamondFoundry, ERC721A {
    IFacetRegistry private immutable _facetRegistry;
    address private immutable _diamondImplementation;

    mapping(uint256 tokenId => address proxy) private _diamonds;
    mapping(address proxy => uint256 tokenId) private _tokenIds;

    constructor(IFacetRegistry registry) ERC721A("Diamond Foundry", "FOUNDRY") {
        _facetRegistry = registry;
        _diamondImplementation = address(new DiamondBase(this));

        // zero'th token is used as a sentinel value
        _mint(address(this), 1);
    }

    /// @inheritdoc IDiamondFoundry
    function mintDiamond() external returns (address diamond) {
        uint256 tokenId = _nextTokenId();

        bytes memory initData = abi.encodeWithSelector(DiamondBase.initialize.selector);
        bytes32 salt = keccak256(abi.encode(tokenId, address(this), msg.sender));
        diamond = address(new DiamondBeaconProxy{ salt: salt }(initData));

        // slither-disable-start reentrancy-benign,reentrancy-events
        _diamonds[tokenId] = diamond;
        _tokenIds[diamond] = tokenId;
        emit DiamondMinted(tokenId, diamond);
        // slither-disable-end reentrancy-benign,reentrancy-events

        _safeMint(msg.sender, 1, "");
    }

    /// @inheritdoc IDiamondFoundry
    function diamondAddress(uint256 tokenId) external view returns (address) {
        return _diamonds[tokenId];
    }

    /// @inheritdoc IDiamondFoundry
    function tokenIdOf(address diamond) external view returns (uint256) {
        return _tokenIds[diamond];
    }

    /// @inheritdoc IDiamondFoundry
    function facetRegistry() external view returns (IFacetRegistry) {
        return _facetRegistry;
    }

    /// @inheritdoc IBeacon
    function implementation() external view override returns (address) {
        return _diamondImplementation;
    }
}
