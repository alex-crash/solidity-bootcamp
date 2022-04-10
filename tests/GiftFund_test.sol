// SPDX-License-Identifier: MIT
// Exactpro Solidity Verification course

pragma solidity ^0.8.0;

// This import is automatically injected by Remix
import "remix_tests.sol"; 

// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
// <import file to test>
import "../contracts/GiftFund.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts

contract GiftFundTest is GiftFund(payable(TestsAccounts.getAccount(9)), 1 ether) {
    uint256 private _price = 2 ether;

    address payable private _owner = payable(TestsAccounts.getAccount(0)); //owner by default
    address payable private _this = payable(address(this)); //new owner

    address payable private _depositor1= payable(TestsAccounts.getAccount(1));
    address payable private _depositor2= payable(TestsAccounts.getAccount(2));
    address payable private _depositor3= payable(TestsAccounts.getAccount(3));

    address payable private _seller = payable(TestsAccounts.getAccount(8)); //recipient

    GiftFund private _giftFund;

    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        // <instantiate contract>
        _giftFund = new GiftFund(_seller, _price);
    }

    /// Custom Transaction Context: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    function checkOwner() public {
        // Use 'Assert' methods: https://remix-ide.readthedocs.io/en/latest/assert_library.html
        Assert.equal(owner(), _owner, "Invalid owner");
    }

    /// Custom Transaction Context: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    /// #sender: account-0
    function changeOwner() public payable {
        // account index varies 0-9, value is in wei
        // Use 'Assert' methods: https://remix-ide.readthedocs.io/en/latest/assert_library.html
        Assert.equal(msg.sender, _owner, "Invalid sender");
        Assert.equal(msg.value, 0, "Invalid value");

        transferOwnership(_this);
        
        Assert.equal(owner(), _this, "Invalid owner");
    }
    
    /// Custom Transaction Context: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    /// #sender: account-1
    /// #value: 999999999999999999
    function singleDeposit() public payable {
        // account index varies 0-9, value is in wei
        // Use 'Assert' methods: https://remix-ide.readthedocs.io/en/latest/assert_library.html
        Assert.equal(msg.sender, _depositor1, "Invalid sender");
        Assert.equal(msg.value, 999999999999999999, "Invalid value");

        try this.deposit() {
            Assert.equal(total(), msg.value, "Invalid value");
        } catch Error(string memory /*reason*/) {
            // This is executed in case
            // revert was called inside getData
            // and a reason string was provided.
            Assert.ok(false, 'failed with reason');
        }
    }

    /// Custom Transaction Context: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    /// #sender: account-2
    function killContract() public payable {
        // account index varies 0-9, value is in wei
        // Use 'Assert' methods: https://remix-ide.readthedocs.io/en/latest/assert_library.html
        Assert.equal(msg.sender, _depositor2, "Invalid sender");
        Assert.equal(msg.value, 0, "Invalid value");

        try this.kill() {
            Assert.ok(false, "kill should fail if total balance is not euqal to zero");
        } catch Error(string memory reason) {
            // This is executed in case
            // revert was called inside getData
            // and a reason string was provided.
            Assert.equal(reason, "You are not permitted to terminate the contract until all the money is used for its intended purpose!", "failed with unexpected reason");
        }
    }
    
    /// Custom Transaction Context: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    /// #sender: account-1
    /// #value: 1
    function MultipleDeposit1() public payable {
        // account index varies 0-9, value is in wei
        // Use 'Assert' methods: https://remix-ide.readthedocs.io/en/latest/assert_library.html
        Assert.equal(msg.sender, _depositor1, "Invalid sender");
        Assert.equal(msg.value, 1, "Invalid value");

        try _giftFund.deposit{value: 1}() {
            Assert.equal(_giftFund.total(), 1, "Invalid value");
        } catch Error(string memory /*reason*/) {
            // This is executed in case
            // revert was called inside getData
            // and a reason string was provided.
            Assert.ok(false, 'failed with reason');
        }
    }

    /// Custom Transaction Context: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    /// #sender: account-2
    /// #value: 2
    function MultipleDeposit2() public payable {
        // account index varies 0-9, value is in wei
        // Use 'Assert' methods: https://remix-ide.readthedocs.io/en/latest/assert_library.html
        Assert.equal(msg.sender, _depositor2, "Invalid sender");
        Assert.equal(msg.value, 2, "Invalid value");

        try _giftFund.deposit{value: 2}() {
            Assert.equal(_giftFund.total(), 3, "Invalid value");
        } catch Error(string memory /*reason*/) {
            // This is executed in case
            // revert was called inside getData
            // and a reason string was provided.
            Assert.ok(false, 'failed with reason');
        }
    }

    /// Custom Transaction Context: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    /// #sender: account-3
    /// #value: 3
    function MultipleDeposit3() public payable {
        // account index varies 0-9, value is in wei
        // Use 'Assert' methods: https://remix-ide.readthedocs.io/en/latest/assert_library.html
        Assert.equal(msg.sender, _depositor3, "Invalid sender");
        Assert.equal(msg.value, 3, "Invalid value");

        try _giftFund.deposit{value: 3}() {
            Assert.equal(_giftFund.total(), 6, "Invalid value");
        } catch Error(string memory /*reason*/) {
            // This is executed in case
            // revert was called inside getData
            // and a reason string was provided.
            Assert.ok(false, 'failed with reason');
        }
    }
    
    /// Custom Transaction Context: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    /// #sender: account-0
    function GiftPurshase() public payable {
        // account index varies 0-9, value is in wei
        // Use 'Assert' methods: https://remix-ide.readthedocs.io/en/latest/assert_library.html
        Assert.equal(msg.sender, _owner, "Invalid sender");
        Assert.equal(msg.value, 0, "Invalid value");

        try _giftFund.purchase() {
            Assert.equal(_giftFund.total(), 0, "Invalid value");
            Assert.equal(total(), 1000000000000000005, "Invalid value");
        } catch Error(string memory /*reason*/) {
            // This is executed in case
            // revert was called inside getData
            // and a reason string was provided.
            Assert.ok(false, 'failed with reason');
        }
    }

    /// Custom Transaction Context: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    receive() external payable {}
}