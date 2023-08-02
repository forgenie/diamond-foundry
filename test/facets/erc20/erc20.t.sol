// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { FacetTest, FacetHelper, Diamond } from "../Facet.t.sol";
import { IERC20Base } from "src/facets/erc20/IERC20Base.sol";
import { ERC20Facet, IERC20 } from "src/facets/erc20/ERC20Facet.sol";

abstract contract ERC20FacetTest is IERC20Base, FacetTest {
    string public name = "TestToken";
    string public symbol = "TEST";
    uint8 public decimals = 18;
    IERC20 public erc20;

    function setUp() public virtual override {
        super.setUp();

        erc20 = IERC20(diamond);
    }

    function diamondInitParams() public override returns (Diamond.InitParams memory) {
        ERC20FacetHelper erc20Helper = new ERC20FacetHelper();

        FacetCut[] memory baseFacets = new FacetCut[](1);
        baseFacets[0] = erc20Helper.makeFacetCut(FacetCutAction.Add);

        return Diamond.InitParams({
            baseFacets: baseFacets,
            init: erc20Helper.facet(),
            initData: abi.encodeWithSelector(erc20Helper.initializer(), name, symbol, decimals)
        });
    }
}

contract ERC20FacetHelper is FacetHelper {
    ERC20Facet public erc20Facet;

    constructor() {
        erc20Facet = new ERC20Facet();
    }

    function facet() public view override returns (address) {
        return address(erc20Facet);
    }

    function selectors() public pure override returns (bytes4[] memory selectors_) {
        selectors_ = new bytes4[](9);
        selectors_[0] = ERC20Facet.transfer.selector;
        selectors_[1] = ERC20Facet.allowance.selector;
        selectors_[2] = ERC20Facet.approve.selector;
        selectors_[3] = ERC20Facet.balanceOf.selector;
        selectors_[4] = ERC20Facet.decimals.selector;
        selectors_[5] = ERC20Facet.name.selector;
        selectors_[6] = ERC20Facet.symbol.selector;
        selectors_[7] = ERC20Facet.totalSupply.selector;
        selectors_[8] = ERC20Facet.transferFrom.selector;
    }

    function supportedInterfaces() public pure override returns (bytes4[] memory interfaces) {
        interfaces = new bytes4[](1);
        interfaces[0] = type(IERC20).interfaceId;
    }

    function initializer() public pure override returns (bytes4) {
        return ERC20Facet.ERC20_init.selector;
    }

    function creationCode() public pure override returns (bytes memory) {
        return type(ERC20Facet).creationCode;
    }

    function makeInitData(bytes memory args) public view override returns (MultiInit memory) {
        (string memory name, string memory symbol, uint8 decimals) = abi.decode(args, (string, string, uint8));
        return MultiInit({ init: facet(), initData: abi.encodeWithSelector(initializer(), name, symbol, decimals) });
    }
}
