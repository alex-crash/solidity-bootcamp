// SPDX-License-Identifier: MIT
// Exactpro Solidity Verification course

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.5.0/contracts/access/Ownable.sol";

/**
 * @title `Killable`
 * @dev Allows the contract to kill itself and send all the money from the contract account to its owner.
 */
abstract contract Killable is Ownable {
    /**
     * @dev Kills the contract.
     */
    function kill() public virtual onlyOwner {
        selfdestruct(payable(owner()));
    }
}