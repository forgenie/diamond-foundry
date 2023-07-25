// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { FacetTest, FacetHelper, Diamond } from "../Facet.t.sol";
import { IERC20Base } from "src/facets/erc20/IERC20Base.sol";
import { ERC20Facet, IERC20, IERC20Metadata } from "src/facets/erc20/ERC20Facet.sol";

abstract contract ERC20FacetTest is IERC20Base, FacetTest {
    IERC20 public erc20;

    function setUp() public virtual override {
        super.setUp();

        erc20 = IERC20(diamond);
    }

    function diamondInitParams() public override returns (Diamond.InitParams memory) {
        // todo:
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
        interfaces = new bytes4[](2);
        interfaces[0] = type(IERC20).interfaceId;
        interfaces[1] = type(IERC20Metadata).interfaceId;
    }

    function initializer() public pure override returns (bytes4) {
        return ERC20Facet.ERC20_init.selector;
    }
}
