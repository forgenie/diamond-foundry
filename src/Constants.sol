// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

/// @dev Address used to identify a multi delegate call in a diamond cut.
address constant MULTI_INIT_ADDRESS = 0xD1a302d1A302d1A302d1A302d1A302D1A302D1a3;

/// @dev Default admin role value.
uint8 constant DEFAULT_ADMIN_ROLE = 0;

/// @dev Role value for minting.
uint8 constant MINTER_ROLE = 1;

/// @dev Role value for burning.
uint8 constant BURNER_ROLE = 2;
