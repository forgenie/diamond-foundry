// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { FacetTest, FacetHelper } from "test/facets/Facet.t.sol";
import { Diamond } from "src/Diamond.sol";
import { IOwnable2Step, Ownable2StepFacet } from "src/facets/ownable2step/Ownable2StepFacet.sol";
import { OwnableFacetHelper } from "test/facets/ownable/ownable.t.sol";

// todo: write test cases
abstract contract Ownable2StepFacetTest_ReplaceOwnable is FacetTest {
    address public pendingOwner;
    Ownable2StepFacet public ownable2Step;

    function setUp() public virtual override {
        super.setUp();

        ownable2Step = Ownable2StepFacet(diamond);
    }

    function diamondInitParams() internal override returns (Diamond.InitParams memory) {
        OwnableFacetHelper ownableHelper = new OwnableFacetHelper();
        OwnableReplaceHelper ownable2StepHelper = new OwnableReplaceHelper();

        bytes4[] memory replaceSelectors = new bytes4[](1);
        // ownable() function does not need to be replaced
        replaceSelectors[0] = Ownable2StepFacet.transferOwnership.selector;

        FacetCut[] memory baseFacets = new FacetCut[](3);
        baseFacets[0] = ownableHelper.makeFacetCut(FacetCutAction.Replace);
        baseFacets[1] = ownable2StepHelper.makeFacetCut(FacetCutAction.Add);

        FacetInit[] memory diamondInitData = new FacetInit[](2);
        diamondInitData[0] = ownableHelper.makeInitData(abi.encode(users.owner));
        diamondInitData[1] = ownable2StepHelper.makeInitData("");

        return Diamond.InitParams({
            baseFacets: baseFacets,
            init: address(ownable2StepHelper),
            initData: abi.encodeWithSelector(ownable2StepHelper.multiDelegateCall.selector, diamondInitData)
        });
    }
}

contract OwnableReplaceHelper is FacetHelper {
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

    // todo: make replace facet cut
}
