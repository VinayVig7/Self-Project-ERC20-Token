// SPDX-License-Identifier: MIT

// Layout of Contract:
// version
// imports
// interfaces, libraries, contracts
// errors
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

pragma solidity ^0.8.24;

contract MySelfTokenERC20 {
    ////////////
    // Errors //
    ///////////
    error MySelfTokenERC20__InSufficientBalance();
    error MySelfTokenERC20__InValidAddress();
    error MySelfTokenERC20__SpendingLimitExceeded();

    /////////////////////
    // State Variables //
    ////////////////////
    string public constant name = "MySelfToken";
    string public constant symbol = "MST";
    uint8 public constant decimals = 18;
    uint256 private immutable i_totalSupply;
    address private immutable i_owner;

    mapping(address => uint256) public s_balanceOfToken;
    mapping(address => mapping(address => uint256)) public s_allowances;

    ////////////
    // Events //
    ///////////
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    ///////////////
    // Functions //
    //////////////
    constructor(uint256 supply) {
        i_totalSupply = supply;
        i_owner = msg.sender;
        s_balanceOfToken[msg.sender] = supply;
    }

    /**
     * @dev Transfers `amount` tokens from the caller's account to the `to` address.
     * Reverts if the caller has insufficient balance or if the recipient is the zero address.
     * Emits a {Transfer} event.
     * @param to The recipient address of the tokens.
     * @param amount The number of tokens to transfer.
     * @return bool Returns true if the transfer was successful.
     */
    function transfer(address to, uint256 amount) public returns (bool) {
        if (to == address(0)) {
            revert MySelfTokenERC20__InValidAddress();
        }
        if (s_balanceOfToken[msg.sender] < amount) {
            revert MySelfTokenERC20__InSufficientBalance();
        }
        s_balanceOfToken[msg.sender] -= amount;
        s_balanceOfToken[to] += amount;

        emit Transfer(msg.sender, to, amount);

        return true;
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     * Emits an {Approval} event.
     *
     * Requirements:
     * - `spender` cannot be the zero address.
     *
     * @param spender The address which will be allowed to spend tokens.
     * @param amount The number of tokens that `spender` is allowed to spend.
     * @return bool Returns true if the operation was successful.
     */
    function approve(address spender, uint256 amount) public returns (bool) {
        if (spender == address(0)) {
            revert MySelfTokenERC20__InValidAddress();
        }
        s_allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the allowance mechanism.
     * `amount` is then deducted from the caller's (spender's) allowance.
     * Emits a {Transfer} event.
     *
     * Requirements:
     * - `from` and `to` cannot be the zero address.
     * - `from` must have at least `amount` tokens.
     * - Caller (`msg.sender`) must have sufficient allowance for `from`'s tokens.
     *
     * @param from The address which owns the tokens.
     * @param to The address which will receive the tokens.
     * @param amount The number of tokens to transfer.
     * @return bool Returns true if the transfer was successful.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        if (to == address(0) || from == address(0)) {
            revert MySelfTokenERC20__InValidAddress();
        }
        if (s_balanceOfToken[from] < amount) {
            revert MySelfTokenERC20__InSufficientBalance();
        }
        if (s_allowances[from][msg.sender] < amount) {
            revert MySelfTokenERC20__SpendingLimitExceeded();
        }

        s_allowances[from][msg.sender] -= amount;
        s_balanceOfToken[from] -= amount;
        s_balanceOfToken[to] += amount;

        emit Transfer(from, to, amount);

        return true;
    }

    /**
     * @dev Returns the remaining number of tokens that `spender` is allowed to spend
     * on behalf of `owner` through {approve}. This is zero by default.
     *
     * This value changes when {approve} or {transferFrom} is called.
     *
     * @param owner The address which owns the tokens.
     * @param spender The address which will spend the tokens.
     * @return uint256 The remaining number of tokens approved for the spender.
     */
    function allowance(
        address owner,
        address spender
    ) public view returns (uint256) {
        return s_allowances[owner][spender];
    }

    /**
     * @dev Returns the total supply of custom made ERC20 token
     * @return uint256 - Total supply of custom made ERC20 token
     */
    function totalSupply() public view returns (uint256) {
        return i_totalSupply;
    }

    /**
     * @dev Returns the amount of tokens owned by `account`
     * @param account - The address to query
     * @return uint256 - The token balance of the account
     */
    function balanceOf(address account) public view returns (uint256) {
        if (account == address(0)) {
            revert MySelfTokenERC20__InValidAddress();
        }
        return s_balanceOfToken[account];
    }
}
