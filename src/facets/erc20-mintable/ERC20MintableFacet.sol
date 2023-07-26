// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Facet } from "src/facets/Facet.sol";
import { IERC20Mintable } from "./IERC20Mintable.sol";
import { ERC20Base } from "src/facets/erc20/ERC20Base.sol";
import { AccessControlBase } from "src/facets/access-control/AccessControlBase.sol";

contract ERC20MintableFacet is IERC20Mintable, ERC20Base, AccessControlBase, Facet {
    // todo: move constants in separate file at root level
    uint8 public constant MINTER_ROLE = 1;

    function ERC20Mintable_init() external onlyInitializing {
        _setFunctionAccess(this.mint.selector, MINTER_ROLE, true);
        _addInterface(type(IERC20Mintable).interfaceId);
    }

    /// @inheritdoc IERC20Mintable
    function mint(address to, uint256 amount) external onlyAuthorized {
        _mint(to, amount);
    }
}
