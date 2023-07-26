// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Facet } from "src/facets/Facet.sol";
import { IERC20Mintable } from "./IERC20Mintable.sol";
import { ERC20Base } from "src/facets/erc20/ERC20Base.sol";
import { AccessControlBase } from "src/facets/access-control/AccessControlBase.sol";
import { MINTER_ROLE } from "src/Constants.sol";

contract ERC20MintableFacet is IERC20Mintable, ERC20Base, AccessControlBase, Facet {
    function ERC20Mintable_init() external onlyInitializing {
        _setFunctionAccess(this.mint.selector, MINTER_ROLE, true);
        _addInterface(type(IERC20Mintable).interfaceId);
    }

    /// @inheritdoc IERC20Mintable
    function mint(address to, uint256 amount) external protected {
        _mint(to, amount);
    }
}
