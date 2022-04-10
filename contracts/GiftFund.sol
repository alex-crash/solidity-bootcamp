// SPDX-License-Identifier: MIT
// Exactpro Solidity Verification course

pragma solidity ^0.8.0;

import "./utils/structures/Gift.sol";
import "./utils/structures/Balance.sol";
import "./utils/interfaces/IGift.sol";
import "./utils/contracts/Killable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.5.0/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.5.0/contracts/utils/math/SafeMath.sol";

/**
 * @title `GiftFund`
 * @dev This contract allows to store Ether payments among a group of accounts and buy a gift in the future. 
 * Only owner (contract creator) is able to make a decision when to start a gift purchase process.
 *
 * The contract will buy a gift if the collected money is enough.
 * Otherwise it will return the money back to all the contributors.
 *
 * At the end of the life cycle, the contract will be destroyed.
 */
contract GiftFund is Ownable, Killable, IGift {
    // Use OpenZeppelin SafeMath for arithmetic
    using SafeMath for uint256;
    // Attach Balance library functions to Balance.Map type
    using Balance for Balance.Map;

    /**
     * @dev Stores the addresses of contributors and their balances.
     */
    Balance.Map private _balances;

    /**
     * @dev Stores the target gift information.
     */
    Gift.Info private _gift;

    /**
     * @dev Creates an instance of `GiftFund` and stores the target gift information
     *
     * @param seller address of the seller
     * @param price price of the gift
     */
    constructor(address payable seller, uint256 price) {
        // Initialize the target gift parameters.
        _gift = Gift.Info(seller,  price);
    }

    /**
     * @dev Collects money and puts it into the balances. 
     * The Ether received will be logged with {PaymentReceived} events.
     */
    function deposit() external payable override {
        // Add received money to the balance map.
        _balances.add(payable(msg.sender), msg.value);

        // Emit {PaymentReceived} event.
        emit PaymentReceived(msg.value);
    }

    /**
     * @dev Buys the target gift by sending money to the seller if enough money is collected.
     * Otherwise returns money back to the contributors.
     * The gift purchased will be logged with {GiftPurchased} event.
     */
    function purchase() external override onlyOwner {
        // Get total balance.
        uint256 _total = total();

        // Buy the gift and emit {GiftPurchased} event.
        if (_total >= _gift.price) {
            // Send money to the seller.
            _gift.seller.transfer(_gift.price);

            // Emit {GiftPurchased} event.
            emit GiftPurchased(_gift.seller, _gift.price);
        }

        // Give back the change.
        refund();

        // Destroy the contract.
        kill();
    }

    /**
     * @dev Returns money back to the depositors in proportion to their contribution.
     * Formula: contribution = balance / total.
     * Formula: refund = change * contribution.
     * So: refund = change * balance / total.
     */
    function refund() internal onlyOwner {
        // Get change value.
        uint256 _change = total();

        for (uint256 index = 0; index < _balances.size(); index = index.add(1)) {
            // Calculate refund value.
            uint256 value = _change.mul(_balances.getValue(index)).div(_balances.total);

            // Send money to the depositors.
            _balances.getAddress(index).transfer(value);
        }

        // Send the latest payment to the contract owner including rounding errors (if any).
        // Thank you for the contract management :)
        payable(owner()).transfer(total());
    }
    
    /**
     * @dev Returns the total amount of funds raised.
     *
     * @return the total balance.
     */
    function total() public view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @dev Checks if the contract balance is zero, then kills the contract.
     */
    function kill() public override onlyOwner {
        // Check if the contract balance is equal to zero.
        require(total() == 0, "You are not permitted to terminate the contract until all the money is used for its intended purpose!");

        // Destroy the contract.
        super.kill();
    }
}