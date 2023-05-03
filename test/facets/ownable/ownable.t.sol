// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { OwnableBehavior } from "src/facets/ownable/OwnableBehavior.sol";
import { OwnableFacet } from "src/facets/ownable/OwnableFacet.sol";
import { BaseTest } from "test/Base.t.sol";
import { FacetTest } from "../Facet.t.sol";
import { FacetHelper } from "../Helpers.t.sol";

abstract contract OwnableBehaviorTest is FacetTest {
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function setUp() public virtual override {
        facetHelper = new OwnableFacetHelper();

        super.setUp();

        // init
        OwnableBehavior.transferOwnership(users.owner);
    }

    function diamondInitParams() internal override {
        address init = facetHelper.facet();
        bytes memory initData = abi.encodeWithSelector(facetHelper.initializer(), users.owner);

        IDiamond.FacetCut[] memory baseFacets = new IDiamond.FacetCut[](1);
        baseFacets[0] = facetHelper.makeFacetCut(IDiamond.FacetCutAction.Add);

        return Diamond.InitParams({ baseFacets: baseFacets, init: init, initData: initData });
    }
}

contract OwnableFacetHelper is FacetHelper {
    OwnableFacet public ownableFacet;

    constructor() {
        ownableFacet = new OwnableFacet();
    }

    function facet() public override returns (address) {
        return address(ownableFacet);
    }

    function selectors() public override returns (bytes4[] memory selectors_) {
        selectors_ = new bytes4[](2);
        selectors_[0] = OwnableFacet.transferOwnership.selector;
        selectors_[1] = OwnableFacet.owner.selector;
    }

    function supportedInterfaces() public pure override returns (bytes4[] memory interfaces) {
        interfaces = new bytes4[](1);
        interfaces[0] = type(IERC173).interfaceId;
    }

    function initializer() public pure override returns (bytes4) {
        return ownableFacet.initialize.selector;
    }

    function name() public pure override returns (string memory) {
        return "Ownable";
    }
}
