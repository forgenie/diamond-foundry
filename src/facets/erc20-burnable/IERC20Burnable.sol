// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

interface IERC20Burnable {
    /**
     * @notice Burns an amount of the token of the sender.
     * @param amount The amount that will be burnt.
     */
    function burn(uint256 amount) external;

    /**
     * @notice Burns an amount of the token of a given account.
     * @param account The account whose tokens will be burnt.
     * @param amount The amount that will be burnt.
     */
    function burnFrom(address account, uint256 amount) external;
}
