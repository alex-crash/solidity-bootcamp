// SPDX-License-Identifier: MIT
// Exactpro Solidity Verification course

pragma solidity ^0.8.0;

/**
 * @title `IGift`
 * @dev Interface `IGift`specifies a gift behavior.
 */
interface IGift {
    /**
     * @dev Emitted when a new contract payment arrives.
     */
    event PaymentReceived(uint256 indexed value);

    /**
     * @dev Emitted when a gift is purchased.
     */
    event GiftPurchased(address payable indexed seller, uint256 price);

    /**
     * @dev Collects money and puts it on balances.
     */
    function deposit() external payable;

    /**
     * @dev Buys the target gift by sending money to the seller.
     */
    function purchase() external;
}