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

    struct Info {
        uint256 _price;
        address _address;
    }

    Info private _buyer;
    Info private _seller;

    EXP private _exp;
    GBP private _gbp;

    constructor(address exp_, address gbp_) {
        _exp = EXP(exp_);
        _gbp = GBP(gbp_);
    }

    function setBuyerPrice(uint256 price_) public {
        _buyer._price = price_;
        _buyer._address = msg.sender;
    }

    function setSellerPrice(uint256 price_) public {
        _seller._price = price_;
        _seller._address = msg.sender;
    }

    function exchage(uint256 quantity_) public {
        if (_buyer._price >= _seller._price) {
            uint256 input = _buyer._price.mul(quantity_);
            uint256 output = _seller._price.mul(quantity_);

            _exp.transferFrom(_seller._address, _buyer._address, quantity_);
            _gbp.transferFrom(_buyer._address, _seller._address, output);

            _gbp.transferFrom(_buyer._address, address(this), input.sub(output, "The transaction fee cannot be negative"));
        }
    }
}