// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

library ERC20Storage {
    bytes32 private constant _ERC20_STORAGE_SLOT = keccak256("erc20.storage");

    struct Layout {
        mapping(address => uint256) balances;
        mapping(address => mapping(address => uint256)) allowances;
        uint256 totalSupply;
        uint8 decimals;
        string name;
        string symbol;
    }

    function layout() internal pure returns (Layout storage l) {
        bytes32 position = _ERC20_STORAGE_SLOT;
        assembly {
            l.slot := position
        }
    }
}
