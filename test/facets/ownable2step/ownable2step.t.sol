// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { FacetTest } from "test/facets/Facet.t.sol";
import { FacetHelper } from "../Helpers.t.sol";
import { IERC173, IOwnableEvents } from "src/facets/ownable/IERC173.sol";
import { IOwnable2Step, IOwnable2StepEvents } from "src/facets/ownable2step/IOwnable2Step.sol";
import { Ownable2StepFacet } from "src/facets/ownable2step/Ownable2StepFacet.sol";
import { Diamond } from "src/Diamond.sol";
import { OwnableFacet } from "src/facets/ownable/OwnableFacet.sol";

abstract contract Ownable2StepFacetTest is IOwnableEvents, IOwnable2StepEvents, FacetTest {
    address public pendingOwner;
    Ownable2StepFacet public ownable2Step;

    function setUp() public virtual override {
        super.setUp();

        pendingOwner = makeAddr("pendingOwner");

        ownable2Step = Ownable2StepFacet(diamond);
    }

    function diamondInitParams() internal override returns (Diamond.InitParams memory) {
        Ownable2StepFacetHelper ownable2StepHelper = new Ownable2StepFacetHelper();

        FacetCut[] memory baseFacets = new FacetCut[](1);
        baseFacets[0] = ownable2StepHelper.makeFacetCut(FacetCutAction.Add);

        FacetInit[] memory diamondInitData = new FacetInit[](1);
        diamondInitData[0] = ownable2StepHelper.makeInitData(abi.encode(users.owner));

        return Diamond.InitParams({
            baseFacets: baseFacets,
            init: address(ownable2StepHelper),
            initData: abi.encodeWithSelector(ownable2StepHelper.multiDelegateCall.selector, diamondInitData)
        });
    }
}

contract Ownable2StepFacetHelper is FacetHelper {
    Ownable2StepFacet public ownable2Step;

    constructor() {
        ownable2Step = new Ownable2StepFacet();
    }

    function facet() public view override returns (address) {
        return address(ownable2Step);
    }

    function selectors() public view override returns (bytes4[] memory selectors_) {
        selectors_ = new bytes4[](4);
        selectors_[0] = ownable2Step.acceptOwnership.selector;
        selectors_[1] = ownable2Step.pendingOwner.selector;
        selectors_[2] = ownable2Step.transferOwnership.selector;
        selectors_[3] = ownable2Step.owner.selector;
    }

    function initializer() public view override returns (bytes4) {
        return ownable2Step.initialize.selector;
    }

    function name() public pure override returns (string memory) {
        return "Ownable2StepFacet";
    }

    function supportedInterfaces() public pure override returns (bytes4[] memory interfaces) {
        interfaces = new bytes4[](2);
        interfaces[0] = type(IERC173).interfaceId;
        interfaces[1] = type(IOwnable2Step).interfaceId;
    }

    // NOTE: This is a hack to give the initializer the owner address
    function makeInitData(bytes memory args) public view override returns (FacetInit memory) {
        return FacetInit({ facet: facet(), data: abi.encodeWithSelector(initializer(), abi.decode(args, (address))) });
    }
}

contract OwnableFacetReplaceHelper is FacetHelper {
    Ownable2StepFacet public ownable2Step;

    constructor() {
        ownable2Step = new Ownable2StepFacet();
    }

    function facet() public view override returns (address) {
        return address(ownable2Step);
    }

    function selectors() public view override returns (bytes4[] memory selectors_) {
        selectors_ = new bytes4[](2);
        selectors_[0] = ownable2Step.acceptOwnership.selector;
        selectors_[1] = ownable2Step.pendingOwner.selector;
    }

    function initializer() public view override returns (bytes4) {
        return ownable2Step.initialize_Replace_Ownable.selector;
    }

    function name() public pure override returns (string memory) {
        return "Ownable2StepFacet";
    }

    function supportedInterfaces() public pure override returns (bytes4[] memory interfaces) {
        interfaces = new bytes4[](1);
        interfaces[0] = type(IOwnable2Step).interfaceId;
    }

    function makeFacetCuts(OwnableFacet ownableFacet) public view returns (FacetCut[] memory facetCuts) {
        facetCuts = new FacetCut[](2);
        bytes4[] memory replaceSelectors = new bytes4[](1);
        // ownable() function does not need to be replaced
        replaceSelectors[0] = ownableFacet.transferOwnership.selector;

        facetCuts[0] =
            FacetCut({ action: FacetCutAction.Replace, facet: address(ownableFacet), selectors: replaceSelectors });

        facetCuts[1] = FacetCut({ action: FacetCutAction.Add, facet: address(ownable2Step), selectors: selectors() });
    }
}
