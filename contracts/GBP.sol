// SPDX-License-Identifier: MIT
// Exactpro Solidity Verification course

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.5.0/contracts/token/ERC20/ERC20.sol";

contract GBP is ERC20 {
    // Creates the specified amount of `GBP` tokens.
    constructor(uint256 initialSupply) ERC20("British pound", "GBP") {
        _mint(msg.sender, initialSupply);
    }

    // Sends the specified amount of `GBP` tokens from one account to another.
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(from, to, amount);
        return true;
    }
}