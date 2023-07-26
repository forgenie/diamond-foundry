// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { FacetTest, FacetHelper, Diamond, MULTI_INIT_ADDRESS } from "test/facets/Facet.t.sol";
import { IERC20Burnable, ERC20BurnableFacet } from "src/facets/erc20-burnable/ERC20BurnableFacet.sol";
import { DiamondLoupeFacetHelper } from "test/facets/loupe/loupe.t.sol";
import { ERC20MintableFacetHelper } from "test/facets/erc20-mintable/erc20-mintable.t.sol";
import { AccessControlFacetHelper } from "test/facets/access-control/access-control.t.sol";
import { ERC20FacetHelper } from "test/facets/erc20/erc20.t.sol";
import { IERC20Base } from "src/facets/erc20/IERC20Base.sol";

abstract contract ERC20BurnableFacetTest is IERC20Base, FacetTest {
    IERC20Burnable public erc20Burnable;

    function setUp() public virtual override {
        super.setUp();

        erc20Burnable = IERC20Burnable(diamond);
    }

    function diamondInitParams() public override returns (Diamond.InitParams memory) {
        ERC20FacetHelper erc20Helper = new ERC20FacetHelper();
        ERC20BurnableFacetHelper erc20BurnableHelper = new ERC20BurnableFacetHelper();
        AccessControlFacetHelper aclHelper = new AccessControlFacetHelper();
        DiamondLoupeFacetHelper loupeHelper = new DiamondLoupeFacetHelper();
        ERC20MintableFacetHelper erc20MintableHelper = new ERC20MintableFacetHelper();

        FacetCut[] memory baseFacets = new FacetCut[](5);
        baseFacets[0] = erc20Helper.makeFacetCut(FacetCutAction.Add);
        baseFacets[1] = erc20BurnableHelper.makeFacetCut(FacetCutAction.Add);
        baseFacets[2] = aclHelper.makeFacetCut(FacetCutAction.Add);
        baseFacets[3] = loupeHelper.makeFacetCut(FacetCutAction.Add);
        baseFacets[4] = erc20MintableHelper.makeFacetCut(FacetCutAction.Add);

        MultiInit[] memory diamondInitData = new MultiInit[](5);
        diamondInitData[0] = erc20Helper.makeInitData(abi.encode("TestToken", "TEST", 18));
        diamondInitData[1] = erc20BurnableHelper.makeInitData("");
        diamondInitData[2] = aclHelper.makeInitData(abi.encode(users.owner));
        diamondInitData[3] = loupeHelper.makeInitData("");
        diamondInitData[4] = erc20MintableHelper.makeInitData("");

        return Diamond.InitParams({
            baseFacets: baseFacets,
            init: MULTI_INIT_ADDRESS,
            initData: abi.encode(diamondInitData)
        });
    }
}

contract ERC20BurnableFacetHelper is FacetHelper {
    ERC20BurnableFacet public erc20Burnable;

    constructor() {
        erc20Burnable = new ERC20BurnableFacet();
    }

    function facet() public view override returns (address) {
        return address(erc20Burnable);
    }

    function selectors() public view override returns (bytes4[] memory selectors_) {
        selectors_ = new bytes4[](2);
        selectors_[0] = erc20Burnable.burn.selector;
        selectors_[1] = erc20Burnable.burnFrom.selector;
    }

    function initializer() public view override returns (bytes4) {
        return erc20Burnable.ERC20Burnable_init.selector;
    }

    function supportedInterfaces() public pure override returns (bytes4[] memory interfaces) {
        interfaces = new bytes4[](1);
        interfaces[0] = type(IERC20Burnable).interfaceId;
    }

    function creationCode() public pure override returns (bytes memory code) {
        code = type(ERC20BurnableFacet).creationCode;
    }
}
