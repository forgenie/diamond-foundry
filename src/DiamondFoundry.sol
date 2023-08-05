// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { ERC721A } from "@erc721a/ERC721A.sol";
import { Diamond } from "src/diamond/Diamond.sol";
import { IDiamondFoundry, IFacetRegistry } from "./IDiamondFoundry.sol";
import { FacetRegistry } from "src/registry/FacetRegistry.sol";
import { IDiamondLoupe } from "src/facets/loupe/IDiamondLoupe.sol";

contract DiamondFoundry is IDiamondFoundry, FacetRegistry, ERC721A {
    mapping(uint256 tokenId => address proxy) private _diamonds;
    mapping(address proxy => uint256 tokenId) private _tokenIds;

    // solhint-disable-next-line no-empty-blocks
    constructor() ERC721A("Diamond Foundry", "FOUNDRY") { }

    /// @inheritdoc IDiamondFoundry
    function mintDiamond(Diamond.InitParams calldata initDiamondCut) external returns (address diamond) {
        uint256 tokenId = _nextTokenId();

        diamond = address(new Diamond{ salt: bytes32(tokenId) }(initDiamondCut));
        if (!IDiamondLoupe(diamond).supportsInterface(type(IDiamondLoupe).interfaceId)) {
            revert DiamondFoundry_LoupeNotSupported();
        }

        // slither-disable-start reentrancy-benign,reentrancy-events
        _diamonds[tokenId] = diamond;
        _tokenIds[diamond] = tokenId;
        emit DiamondMinted(tokenId, diamond);
        // slither-disable-end reentrancy-benign,reentrancy-events

        _safeMint(msg.sender, 1, "");
    }

    /// @inheritdoc IDiamondFoundry
    function diamondIds(address[] calldata diamonds) external view override returns (uint256[] memory tokenIds) {
        tokenIds = new uint256[](diamonds.length);
        for (uint256 i = 0; i < diamonds.length; i++) {
            tokenIds[i] = _tokenIds[diamonds[i]];
        }
    }

    /// @inheritdoc IDiamondFoundry
    function diamondAddresses(uint256[] calldata tokenIds) external view override returns (address[] memory diamonds) {
        diamonds = new address[](tokenIds.length);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            diamonds[i] = _diamonds[tokenIds[i]];
        }
    }

    /// @inheritdoc IDiamondFoundry
    function diamondAddress(uint256 tokenId) external view returns (address) {
        return _diamonds[tokenId];
    }

    /// @inheritdoc IDiamondFoundry
    function diamondId(address diamond) external view returns (uint256) {
        return _tokenIds[diamond];
    }

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }
}
