// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

interface IERC20Mintable {
    /**
     * @notice Mints new tokens to the given address.
     * @param to The address to mint tokens to.
     * @param amount The amount of tokens to mint.
     */
    function mint(address to, uint256 amount) external;
}
