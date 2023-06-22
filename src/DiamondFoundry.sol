// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { UpgradeableBeacon } from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import { ERC721A } from "@erc721a/ERC721A.sol";
import { Diamond } from "src/diamond/Diamond.sol";
import { IDiamondFoundry, IFacetRegistry } from "./IDiamondFoundry.sol";
import { DiamondFactoryBase } from "src/factory/DiamondFactory.sol";

contract DiamondFoundry is IDiamondFoundry, DiamondFactoryBase, ERC721A, UpgradeableBeacon {
    IFacetRegistry private immutable _facetRegistry;

    mapping(uint256 tokenId => address proxy) private _diamonds;
    mapping(address proxy => uint256 tokenId) private _tokenIds;

    constructor(
        IFacetRegistry registry,
        address diamondImplementation
    )
        ERC721A("Diamond Foundry", "FOUNDRY")
        UpgradeableBeacon(diamondImplementation)
    {
        _facetRegistry = registry;

        // zero'th token is used as a sentinel value
        _mint(address(this), 1);
    }

    /// @inheritdoc IDiamondFoundry
    function mintDiamond(Diamond.InitParams calldata initDiamondCut) external returns (address diamond) {
        uint256 tokenId = _nextTokenId();

        bytes32 salt = keccak256(abi.encode(tokenId, address(this), msg.sender));
        diamond = _deployDiamondBeacon(address(this), salt, initDiamondCut);

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
    function diamondId(address diamond) external view returns (uint256) {
        return _tokenIds[diamond];
    }

    /// @inheritdoc IDiamondFoundry
    function facetRegistry() external view returns (IFacetRegistry) {
        return _facetRegistry;
    }
}
