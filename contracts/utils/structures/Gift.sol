// SPDX-License-Identifier: MIT
// Exactpro Solidity Verification course

pragma solidity ^0.8.0;

/**
 * @dev Library for managing a gift representation.
 */
library Gift {
    /**
     * @dev `Info` contains an address of a seller and a price of a gift.
     */
    struct Info {
        address payable seller;
        uint256 price;
    }
}