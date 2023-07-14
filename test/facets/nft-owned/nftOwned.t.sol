// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { FacetTest, IDiamond, Diamond, FacetHelper } from "../Facet.t.sol";
import { INFTOwned, NFTOwnedFacet } from "src/facets/nft-owned/NFTOwnedFacet.sol";
import { MockERC721 } from "test/mocks/MockERC721.sol";

abstract contract NFTOwnedTest is FacetTest {
    INFTOwned public nftOwned;
    MockERC721 public tokenContract;
    uint256 public tokenId = 123;

    function setUp() public virtual override {
        tokenContract = new MockERC721();
        tokenContract.mint(address(1), tokenId);

        super.setUp();

        nftOwned = INFTOwned(diamond);
    }

    function diamondInitParams() internal override returns (Diamond.InitParams memory) {
        NFTOwnedFacetHelper nftOwnedHelper = new NFTOwnedFacetHelper();

        IDiamond.FacetCut[] memory baseFacets = new IDiamond.FacetCut[](1);
        baseFacets[0] = nftOwnedHelper.makeFacetCut(IDiamond.FacetCutAction.Add);

        IDiamond.MultiInit[] memory diamondInitData = new IDiamond.MultiInit[](1);
        diamondInitData[0] = nftOwnedHelper.makeInitData(abi.encode(address(tokenContract), tokenId));

        return Diamond.InitParams({
            baseFacets: baseFacets,
            init: MULTI_INIT_ADDRESS,
            initData: abi.encode(diamondInitData)
        });
    }
}

contract NFTOwnedFacetHelper is FacetHelper {
    NFTOwnedFacet public nftOwned;

    constructor() {
        nftOwned = new NFTOwnedFacet();
    }

    function facet() public view override returns (address) {
        return address(nftOwned);
    }

    function supportedInterfaces() public pure override returns (bytes4[] memory interfaces) {
        interfaces = new bytes4[](1);
        interfaces[0] = type(INFTOwned).interfaceId;
    }

    function selectors() public pure override returns (bytes4[] memory facetSelectors) {
        facetSelectors = new bytes4[](2);
        facetSelectors[0] = INFTOwned.token.selector;
        facetSelectors[1] = INFTOwned.owner.selector;
    }

    function initializer() public pure override returns (bytes4) {
        return NFTOwnedFacet.NFTOwned_init.selector;
    }

    function makeInitData(bytes memory args) public view override returns (IDiamond.MultiInit memory) {
        (address tokenContract, uint256 tokenId) = abi.decode(args, (address, uint256));
        return IDiamond.MultiInit({
            init: facet(),
            initData: abi.encodeWithSelector(initializer(), tokenContract, tokenId)
        });
    }
}
