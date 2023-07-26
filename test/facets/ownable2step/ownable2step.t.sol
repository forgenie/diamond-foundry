// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { FacetTest, FacetHelper, MULTI_INIT_ADDRESS, Diamond } from "test/facets/Facet.t.sol";
import { IERC173, IOwnableBase } from "src/facets/ownable/IERC173.sol";
import { IOwnable2Step, IOwnable2StepBase } from "src/facets/ownable2step/IOwnable2Step.sol";
import { Ownable2StepFacet } from "src/facets/ownable2step/Ownable2StepFacet.sol";
import { OwnableFacet } from "src/facets/ownable/OwnableFacet.sol";
import { OwnableFacetHelper } from "test/facets/ownable/ownable.t.sol";

abstract contract Ownable2StepFacetTest is IOwnableBase, IOwnable2StepBase, FacetTest {
    address public pendingOwner;
    Ownable2StepFacet public ownable2Step;

    function setUp() public virtual override {
        super.setUp();

        pendingOwner = makeAddr("pendingOwner");
        ownable2Step = Ownable2StepFacet(diamond);
    }

    function diamondInitParams() public override returns (Diamond.InitParams memory) {
        OwnableFacetHelper ownableHelper = new OwnableFacetHelper();
        Ownable2StepFacetHelper ownable2StepHelper = new Ownable2StepFacetHelper();

        FacetCut[] memory baseFacets = new FacetCut[](1);
        baseFacets[0] = ownable2StepHelper.makeFacetCut(FacetCutAction.Add);

        MultiInit[] memory diamondInitData = new MultiInit[](2);
        diamondInitData[0] = ownable2StepHelper.makeInitData("");
        diamondInitData[1] = ownableHelper.makeInitData(abi.encode(users.owner));

        return Diamond.InitParams({
            baseFacets: baseFacets,
            init: MULTI_INIT_ADDRESS,
            initData: abi.encode(diamondInitData)
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
        return ownable2Step.Ownable2Step_init.selector;
    }

    function supportedInterfaces() public pure override returns (bytes4[] memory interfaces) {
        interfaces = new bytes4[](2);
        interfaces[0] = type(IERC173).interfaceId;
        interfaces[1] = type(IOwnable2Step).interfaceId;
    }

    function creationCode() public pure override returns (bytes memory) {
        return type(Ownable2StepFacet).creationCode;
    }
}
