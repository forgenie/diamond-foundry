// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { FacetTest, FacetHelper } from "test/facets/Facet.t.sol";
import { IERC173, IOwnableEvents } from "src/facets/ownable/IERC173.sol";
import { IOwnable2Step, IOwnable2StepEvents } from "src/facets/ownable2step/IOwnable2Step.sol";
import { Ownable2StepFacet } from "src/facets/ownable2step/Ownable2StepFacet.sol";
import { IDiamond, Diamond } from "src/diamond/Diamond.sol";
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

        IDiamond.FacetCut[] memory baseFacets = new IDiamond.FacetCut[](1);
        baseFacets[0] = ownable2StepHelper.makeFacetCut(IDiamond.FacetCutAction.Add);

        IDiamond.FacetInit[] memory diamondInitData = new IDiamond.FacetInit[](1);
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

    function supportedInterfaces() public pure override returns (bytes4[] memory interfaces) {
        interfaces = new bytes4[](2);
        interfaces[0] = type(IERC173).interfaceId;
        interfaces[1] = type(IOwnable2Step).interfaceId;
    }

    // NOTE: This is a hack to give the initializer the owner address
    function makeInitData(bytes memory args) public view override returns (IDiamond.FacetInit memory) {
        return IDiamond.FacetInit({
            facet: facet(),
            data: abi.encodeWithSelector(initializer(), abi.decode(args, (address)))
        });
    }
}
