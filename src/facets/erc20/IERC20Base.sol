// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

interface IERC20Base {
    /// @notice Thrown when approving from zero address.
    error ERC20_ApproveFromZeroAddress();

    /// @notice Thrown when approving to zero address.
    error ERC20_ApproveToZeroAddress();

    /// @notice Thrown when burn amount exceeds balance.
    error ERC20_BurnExceedsBalance();

    /// @notice Thrown when burning is made on from zero address.
    error ERC20_BurnFromZeroAddress();

    /// @notice Thrown when spending allowance exceeds allowed amount.
    error ERC20_InsufficientAllowance();

    /// @notice Thrown when minting to zero address.
    error ERC20_MintToZeroAddress();

    /// @notice Thrown when transfer amount exceeds balance.
    error ERC20_TransferExceedsBalance();

    /// @notice Thrown when transfer is made from zero address, outside mint function.
    error ERC20_TransferFromZeroAddress();

    /// @notice Thrown when transfer is made to zero address, outside burn function.
    error ERC20_TransferToZeroAddress();

    /// @notice Thrown when transfer is made to self, i.e. from == to.
    error ERC20_TransferToSelf();

    /**
     * @notice Emitted when tokens are transferred from one account to another.
     * @param from The account where the tokens are transferred from.
     * @param to The account where the tokens are transferred to.
     * @param value The number of tokens transferred.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @notice Emitted when the allowance of a spender for an owner is approved.
     * @param owner The account that owns the tokens.
     * @param spender The account that is allowed to transfer the tokens.
     * @param value The number of tokens that are approved.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
