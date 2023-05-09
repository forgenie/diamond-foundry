// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { FacetInit } from "src/factory/IDiamondFactory.sol";
import { BaseTest } from "test/Base.t.sol";
import { Diamond, IDiamond } from "src/Diamond.sol";
import { OwnableBehavior } from "src/facets/ownable/OwnableBehavior.sol";
import { OwnableFacet, IERC173 } from "src/facets/ownable/OwnableFacet.sol";
import { FacetTest } from "../Facet.t.sol";
import { FacetHelper } from "../Helpers.t.sol";

abstract contract OwnableBehaviorTest is FacetTest {
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    OwnableFacetHelper public ownableFacetHelper;

    function setUp() public virtual override {
        ownableFacetHelper = new OwnableFacetHelper();

        super.setUp();

        // init
        OwnableBehavior.transferOwnership(users.owner);
    }

    function diamondInitParams() internal view override returns (Diamond.InitParams memory) {
        address init = ownableFacetHelper.facet();
        bytes memory initData = abi.encodeWithSelector(ownableFacetHelper.initializer(), users.owner);

        IDiamond.FacetCut[] memory baseFacets = new IDiamond.FacetCut[](1);
        baseFacets[0] = ownableFacetHelper.makeFacetCut(IDiamond.FacetCutAction.Add);

        return Diamond.InitParams({ baseFacets: baseFacets, init: init, initData: initData });
    }
}

contract OwnableFacetHelper is FacetHelper {
    OwnableFacet public ownableFacet;

    constructor() {
        ownableFacet = new OwnableFacet();
    }

    function facet() public view override returns (address) {
        return address(ownableFacet);
    }

    function selectors() public pure override returns (bytes4[] memory selectors_) {
        selectors_ = new bytes4[](2);
        selectors_[0] = OwnableFacet.transferOwnership.selector;
        selectors_[1] = OwnableFacet.owner.selector;
    }

    function supportedInterfaces() public pure override returns (bytes4[] memory interfaces) {
        interfaces = new bytes4[](1);
        interfaces[0] = type(IERC173).interfaceId;
    }

    function initializer() public pure override returns (bytes4) {
        return OwnableFacet.initialize.selector;
    }

    function name() public pure override returns (string memory) {
        return "Ownable";
    }

    function makeInitData(bytes memory args) public view override returns (FacetInit memory) {
        return FacetInit({ facet: facet(), data: abi.encodeWithSelector(initializer(), abi.decode(args, (address))) });
    }
}
