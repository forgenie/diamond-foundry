// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { IERC20 } from "./IERC20.sol";
import { ERC20Base } from "./ERC20Base.sol";
import { Facet } from "src/facets/Facet.sol";

contract ERC20Facet is IERC20, ERC20Base, Facet {
    function ERC20_init(string memory name_, string memory symbol_, uint8 decimals_) external onlyInitializing {
        __ERC20_init(name_, symbol_, decimals_);
    }

    /// @inheritdoc IERC20
    function name() external view returns (string memory) {
        return _name();
    }

    /// @inheritdoc IERC20
    function symbol() external view returns (string memory) {
        return _symbol();
    }

    /// @inheritdoc IERC20
    function decimals() external view returns (uint8) {
        return _decimals();
    }

    /// @inheritdoc IERC20
    function transfer(address to, uint256 amount) external returns (bool) {
        return _transfer(msg.sender, to, amount);
    }

    /// @inheritdoc IERC20
    function approve(address spender, uint256 amount) external returns (bool) {
        return _approve(msg.sender, spender, amount);
    }

    /// @inheritdoc IERC20
    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        return _transferFrom(from, to, amount);
    }

    /// @inheritdoc IERC20
    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowance(owner, spender);
    }

    /// @inheritdoc IERC20
    function totalSupply() external view returns (uint256) {
        return _totalSupply();
    }

    /// @inheritdoc IERC20
    function balanceOf(address account) external view returns (uint256) {
        return _balanceOf(account);
    }
}
