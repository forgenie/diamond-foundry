// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

/**
 * @title ERC20 interface
 * @dev See https://eips.ethereum.org/EIPS/eip-20.
 */
interface IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);

    /**
     * @notice Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @notice Returns the amount of tokens owned by an account.
     * @param account The account to get the balance of.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @notice Moves an amount of tokens from the caller's account to another account.
     * @param to The account where the tokens are transferred to.
     * @param amount The number of tokens transferred.
     * @return Boolean value indicating whether the operation succeeded.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @notice Returns the remaining number of tokens that spender will be allowed to spend on behalf of owner.
     * @dev This value changes when {approve} or {transferFrom} are called and is zero by default.
     * @param owner The account that owns the tokens.
     * @param spender The account that is allowed to transfer the tokens.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @notice Sets an amount as the allowance of spender over the caller's tokens.
     * @param spender The account that is allowed to transfer the tokens.
     * @param amount The number of tokens that are approved.
     * @return bool value indicating whether the operation succeeded.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @notice Transferrs an amount of tokens from an account to other using the allowance mechanism.
     * @dev Amount is deducted from the caller's allowance.
     * @param from The account where the tokens are transferred from.
     * @param to The account where the tokens are transferred to.
     * @param amount The number of tokens transferred.
     * @return bool value indicating whether the operation succeeded.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}
