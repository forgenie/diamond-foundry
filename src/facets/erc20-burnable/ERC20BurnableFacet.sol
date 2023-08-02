// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Facet } from "src/facets/Facet.sol";
import { IERC20Burnable } from "./IERC20Burnable.sol";
import { ERC20Base } from "src/facets/erc20/ERC20Base.sol";
import { AccessControlBase } from "src/facets/access-control/AccessControlBase.sol";
import { BURNER_ROLE } from "src/Constants.sol";

contract ERC20BurnableFacet is IERC20Burnable, ERC20Base, AccessControlBase, Facet {
    function ERC20Burnable_init() external {
        _setFunctionAccess(this.burn.selector, BURNER_ROLE, true);
        _setFunctionAccess(this.burnFrom.selector, BURNER_ROLE, true);
        _addInterface(type(IERC20Burnable).interfaceId);
    }

    /// @inheritdoc IERC20Burnable
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    /// @inheritdoc IERC20Burnable
    function burnFrom(address account, uint256 amount) external protected {
        _burn(account, amount);
    }
}
