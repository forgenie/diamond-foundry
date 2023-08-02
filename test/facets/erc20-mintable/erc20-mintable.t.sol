// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { FacetHelper, FacetTest, Diamond, MULTI_INIT_ADDRESS } from "test/facets/Facet.t.sol";
import { IERC20Mintable } from "src/facets/erc20-mintable/IERC20Mintable.sol";
import { ERC20MintableFacet } from "src/facets/erc20-mintable/ERC20MintableFacet.sol";
import { ERC20FacetHelper } from "test/facets/erc20/erc20.t.sol";
import { AccessControlFacetHelper } from "test/facets/access-control/access-control.t.sol";
import { DiamondLoupeFacetHelper } from "test/facets/loupe/loupe.t.sol";
import { IERC20Base } from "src/facets/erc20/IERC20Base.sol";

abstract contract ERC20MintableFacetTest is IERC20Base, FacetTest {
    IERC20Mintable public erc20Mintable;

    function setUp() public virtual override {
        super.setUp();

        erc20Mintable = IERC20Mintable(diamond);
    }

    function diamondInitParams() public override returns (Diamond.InitParams memory) {
        ERC20FacetHelper erc20Helper = new ERC20FacetHelper();
        ERC20MintableFacetHelper erc20MintableHelper = new ERC20MintableFacetHelper();
        AccessControlFacetHelper aclHelper = new AccessControlFacetHelper();
        DiamondLoupeFacetHelper loupeHelper = new DiamondLoupeFacetHelper();

        FacetCut[] memory baseFacets = new FacetCut[](4);
        baseFacets[0] = erc20Helper.makeFacetCut(FacetCutAction.Add);
        baseFacets[1] = erc20MintableHelper.makeFacetCut(FacetCutAction.Add);
        baseFacets[2] = aclHelper.makeFacetCut(FacetCutAction.Add);
        baseFacets[3] = loupeHelper.makeFacetCut(FacetCutAction.Add);

        MultiInit[] memory diamondInitData = new MultiInit[](4);
        diamondInitData[0] = erc20Helper.makeInitData(abi.encode("TestToken", "TEST", 18));
        diamondInitData[1] = erc20MintableHelper.makeInitData("");
        diamondInitData[2] = aclHelper.makeInitData(abi.encode(users.owner));
        diamondInitData[3] = loupeHelper.makeInitData("");

        return Diamond.InitParams({
            baseFacets: baseFacets,
            init: MULTI_INIT_ADDRESS,
            initData: abi.encode(diamondInitData)
        });
    }
}

contract ERC20MintableFacetHelper is FacetHelper {
    ERC20MintableFacet public erc20MintableFacet;

    constructor() {
        erc20MintableFacet = new ERC20MintableFacet();
    }

    function facet() public view override returns (address) {
        return address(erc20MintableFacet);
    }

    function selectors() public pure override returns (bytes4[] memory selectors_) {
        selectors_ = new bytes4[](1);
        selectors_[0] = ERC20MintableFacet.mint.selector;
    }

    function supportedInterfaces() public pure override returns (bytes4[] memory interfaces) {
        interfaces = new bytes4[](1);
        interfaces[0] = type(IERC20Mintable).interfaceId;
    }

    function initializer() public pure override returns (bytes4) {
        return ERC20MintableFacet.ERC20Mintable_init.selector;
    }

    function creationCode() public pure override returns (bytes memory) {
        return type(ERC20MintableFacet).creationCode;
    }
}
