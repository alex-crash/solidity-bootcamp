// SPDX-License-Identifier: MIT
// Exactpro Solidity Verification course

pragma solidity ^0.8.0;

import "./EXP.sol";
import "./GBP.sol";
import "./utils/contracts/Killable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.5.0/contracts/utils/math/SafeMath.sol";

/**
 * @title `Exchange`
 * @dev Please deploy EXP and GBP contracts first.
 * Exchange rate: EXP/GBP :) Quantity is specified in the base currency.
 */
contract Exchange is Killable {
    using SafeMath for uint256;

    // Buyer/seller address and price.
    struct Info {
        uint256 _price;
        address _address;
    }

    // Buyer and seller info.
    Info private _buyer;
    Info private _seller;

    // Token contracts instances.
    EXP private _exp;
    GBP private _gbp;

    // Creates an instance of `Exchange` and stores `EXP` and `GBP` contracts addresses.
    constructor(address exp_, address gbp_) {
        _exp = EXP(exp_);
        _gbp = GBP(gbp_);
    }

    // Stores buyer info.
    function setBuyerPrice(uint256 price_) public {
        _buyer._price = price_;
        _buyer._address = msg.sender;
    }

    // Stores seller info.
    function setSellerPrice(uint256 price_) public {
        _seller._price = price_;
        _seller._address = msg.sender;
    }

    // Changes base currency to quote currency if bid is greater than offer.
    // The values difference goes to the contract balance :)
    function exchage(uint256 quantity_) public {
        if (_buyer._price >= _seller._price) {
            // Get input and output amount of quoted currency.
            uint256 input = _buyer._price.mul(quantity_);
            uint256 output = _seller._price.mul(quantity_);

            // Send base currency to the buyer and quoted one to the seller.
            _exp.transferFrom(_seller._address, _buyer._address, quantity_);
            _gbp.transferFrom(_buyer._address, _seller._address, output);

            // Send the difference to the contract address.
            _gbp.transferFrom(_buyer._address, address(this), input.sub(output, "The transaction fee cannot be negative"));
        }
    }
}