// SPDX-License-Identifier: MIT
// Exactpro Solidity Verification course

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.5.0/contracts/utils/math/SafeMath.sol";

/**
 * @dev Library for managing a balance representation.
 */
library Balance {
    // Use OpenZeppelin SafeMath for arithmetic
    using SafeMath for uint256;

    /**
     * @dev `Map` contains an array of addresses as well as their balances.
     */
    struct Map {
        address payable[] _addresses;
        mapping (address => uint256) _values;
        mapping (address => bool) _exists;
        uint256 total;
    }
    
    /**
     * @dev Returns the balance address by index.
     *
     * @return the balance address.
     */
    function getAddress(Map storage self, uint256 index) public view returns (address payable) {
        return self._addresses[index];
    }

    /**
     * @dev Returns the balance value by index.
     *
     * @return the balance value.
     */
    function getValue(Map storage self, uint256 index) public view returns (uint256) {
        return self._values[getAddress(self, index)];
    }

    /**
     * @dev Returns the balance map size.
     *
     * @return the balance map size.
     */
    function size(Map storage self) public view returns (uint256) {
        return self._addresses.length;
    }

    /**
     * @dev Puts a new balance or updates an existing one.
     */
    function add(Map storage self, address payable address_, uint256 value) public {
        self._values[address_] = self._values[address_].add(value);
        self.total = self.total.add(value);

        if (!self._exists[address_]) {
            self._addresses.push(address_);
            self._exists[address_] = true;
        }
    }
}