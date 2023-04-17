// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { IDiamond, Diamond } from "src/Diamond.sol";

import { IDiamondCut } from "src/facets/cut/IDiamondCut.sol";
import { IDiamondLoupe } from "src/facets/loupe/DiamondLoupe.sol";
import { IERC165 } from "src/facets/introspection/IERC165.sol";
import { IERC173 } from "src/facets/ownable/IERC173.sol";
import { IDiamondIncremental } from "src/facets/incremental/IDiamondIncremental.sol";
import { DiamondBaseFacet, IDiamondBase } from "src/facets/base/DiamondBaseFacet.sol";
import { Ownable_checkOwner_NotOwner } from "src/facets/ownable/OwnableBehavior.sol";

import { BaseFacetTest } from "test/facets/Facet.t.sol";
import { FacetHelper } from "test/facets/Helpers.t.sol";

contract DiamondBaseFacetTest is BaseFacetTest {
    DiamondBaseFacetHelper public diamondBaseHelper;
    IDiamondBase public diamondBase;

    function setUp() public virtual override {
        diamondBaseHelper = new DiamondBaseFacetHelper();
        facets.push(diamondBaseHelper);

        super.setUp();

        diamondBase = IDiamondBase(diamond);
    }

    function diamondInitParams() internal virtual override returns (Diamond.InitParams memory) {
        address init = diamondBaseHelper.facet();
        bytes memory initData = abi.encodeWithSelector(diamondBaseHelper.initializer(), users.owner);

        IDiamond.FacetCut[] memory baseFacets = new IDiamond.FacetCut[](1);
        baseFacets[0] = diamondBaseHelper.makeFacetCut(IDiamond.FacetCutAction.Add);

        return Diamond.InitParams({ baseFacets: baseFacets, init: init, initData: initData });
    }

    function test_diamondCut_RevertsWhen_CallerIsNotOwner() public {
        IDiamond.FacetCut[] memory cuts = new IDiamond.FacetCut[](1);
        cuts[0] = diamondBaseHelper.makeFacetCut(IDiamond.FacetCutAction.Add);

        vm.startPrank(users.stranger);
        vm.expectRevert(abi.encodeWithSelector(Ownable_checkOwner_NotOwner.selector, users.stranger));
        diamondBase.diamondCut(cuts, address(0), new bytes(0));
    }

    function test_turnImmutable_RevertsWhen_CallerIsNotOnwer() public {
        vm.startPrank(users.stranger);
        vm.expectRevert(abi.encodeWithSelector(Ownable_checkOwner_NotOwner.selector, users.stranger));
        diamondBase.turnImmutable(bytes4(0x12345678));
    }
}

contract DiamondBaseFacetHelper is FacetHelper {
    DiamondBaseFacet internal diamondBaseFacet;

    constructor() {
        diamondBaseFacet = new DiamondBaseFacet();
    }

    function facet() public view override returns (address) {
        return address(diamondBaseFacet);
    }

    function selectors() public view override returns (bytes4[] memory selectors_) {
        selectors_ = new bytes4[](10);
        selectors_[0] = diamondBaseFacet.diamondCut.selector;
        selectors_[1] = diamondBaseFacet.facets.selector;
        selectors_[2] = diamondBaseFacet.facetFunctionSelectors.selector;
        selectors_[3] = diamondBaseFacet.facetAddresses.selector;
        selectors_[4] = diamondBaseFacet.facetAddress.selector;
        selectors_[5] = diamondBaseFacet.supportsInterface.selector;
        selectors_[6] = diamondBaseFacet.owner.selector;
        selectors_[7] = diamondBaseFacet.transferOwnership.selector;
        selectors_[8] = diamondBaseFacet.turnImmutable.selector;
        selectors_[9] = diamondBaseFacet.isImmutable.selector;
    }

    function supportedInterfaces() public pure override returns (bytes4[] memory interfaces) {
        interfaces = new bytes4[](5);
        interfaces[0] = type(IDiamondCut).interfaceId;
        interfaces[1] = type(IDiamondLoupe).interfaceId;
        interfaces[2] = type(IERC165).interfaceId;
        interfaces[3] = type(IERC173).interfaceId;
        interfaces[4] = type(IDiamondIncremental).interfaceId;
    }

    function initializer() public pure override returns (bytes4) {
        return DiamondBaseFacet.initialize.selector;
    }

    function name() public pure override returns (string memory) {
        return "DiamondBase";
    }
}
