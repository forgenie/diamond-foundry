// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { FacetTest, FacetHelper, MULTI_INIT_ADDRESS, Diamond } from "../Facet.t.sol";
import { IOwnableBase, IERC173 } from "src/facets/ownable/IERC173.sol";
import { OwnableFacet } from "src/facets/ownable/OwnableFacet.sol";

abstract contract OwnableFacetTest is IOwnableBase, FacetTest {
    IERC173 public ownable;

    function setUp() public virtual override {
        super.setUp();

        ownable = IERC173(diamond);
    }

    function diamondInitParams() public override returns (Diamond.InitParams memory) {
        OwnableFacetHelper ownableHelper = new OwnableFacetHelper();

        FacetCut[] memory baseFacets = new FacetCut[](1);
        baseFacets[0] = ownableHelper.makeFacetCut(FacetCutAction.Add);

        MultiInit[] memory diamondInitData = new MultiInit[](1);
        diamondInitData[0] = ownableHelper.makeInitData(abi.encode(users.owner));

        return Diamond.InitParams({
            baseFacets: baseFacets,
            init: MULTI_INIT_ADDRESS,
            initData: abi.encode(diamondInitData)
        });
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
        return OwnableFacet.Ownable_init.selector;
    }

    // NOTE: This is a hack to give the initializer the owner address
    function makeInitData(bytes memory args) public view override returns (MultiInit memory) {
        return
            MultiInit({ init: facet(), initData: abi.encodeWithSelector(initializer(), abi.decode(args, (address))) });
    }

    function creationCode() public pure override returns (bytes memory) {
        return type(OwnableFacet).creationCode;
    }
}
