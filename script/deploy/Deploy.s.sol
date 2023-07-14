// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { IERC721A } from "@erc721a/IERC721A.sol";
import { BaseScript } from "../Base.s.sol";
import { IDiamond, Diamond } from "src/diamond/Diamond.sol";
import { DiamondFoundry } from "src/DiamondFoundry.sol";
import { NFTOwnedFacet } from "src/facets/nft-owned/NFTOwnedFacet.sol";

contract Deploy is BaseScript {
    function run() public broadcaster {
        Diamond diamond = new Diamond();
        NFTOwnedFacet nftOwned = new NFTOwnedFacet();
        DiamondFoundry foundry = new DiamondFoundry(address(diamond));
        IDiamond.FacetCut[] memory facetCuts = new IDiamond.FacetCut[](1);
        facetCuts[0] = makeNFTOwnedFacetCut(address(nftOwned));
        foundry.mintDiamond(
            Diamond.InitParams({
                baseFacets: facetCuts,
                init: address(nftOwned),
                initData: makeNFTOwnedInitData(foundry)
            })
        );
    }

    function makeNFTOwnedFacetCut(address nftOwnedFacet) internal pure returns (IDiamond.FacetCut memory) {
        bytes4[] memory selectors = new bytes4[](2);
        selectors[0] = NFTOwnedFacet.token.selector;
        selectors[1] = NFTOwnedFacet.owner.selector;

        return IDiamond.FacetCut({ facet: nftOwnedFacet, action: IDiamond.FacetCutAction.Add, selectors: selectors });
    }

    function makeNFTOwnedInitData(IERC721A nftContract) internal view returns (bytes memory) {
        uint256 tokenId = nftContract.totalSupply();
        return abi.encodeWithSelector(NFTOwnedFacet.NFTOwned_init.selector, nftContract, tokenId);
    }
}
