// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {MySelfTokenERC20} from "src/MySelfTokenERC20.sol";

contract MySelfTokenERC20Test is Test {
    /////////////////////
    // State Variables //
    ////////////////////
    MySelfTokenERC20 token;
    uint256 constant initialSupply = 10_000_000 ether;
    uint256 AMOUNT = 100_000 ether;

    address owner = makeAddr("owner");
    address user = makeAddr("user");
    address receiptient = makeAddr("receiptient");

    ///////////////
    // Modifiers //
    //////////////
    modifier sendingTokenToUser() {
        vm.startPrank(owner);
        token.transfer(user, AMOUNT);
        _;
    }

    ///////////////
    // Functions //
    //////////////
    function setUp() external {
        vm.startPrank(owner);
        token = new MySelfTokenERC20(initialSupply);
        vm.stopPrank();
    }

    function testOwnerGetInitialBalance() public view {
        //Assert
        assertEq(token.balanceOf(owner), initialSupply);
    }

    function testTransferWorking() public {
        // Arrange
        uint256 initialBalanceOfOwner = token.balanceOf(owner);
        uint256 initialBalanceOfUser = token.balanceOf(user);

        // Act
        vm.startPrank(owner);
        token.transfer(user, AMOUNT);
        vm.stopPrank();

        // Assert
        uint256 afterBalanceOfOwner = token.balanceOf(owner);
        uint256 afterBalanceOfUser = token.balanceOf(user);
        assertEq(afterBalanceOfOwner, initialBalanceOfOwner - AMOUNT);
        assertEq(afterBalanceOfUser, initialBalanceOfUser + AMOUNT);
    }

    function testTransferNotToInvalidAddress() public sendingTokenToUser {
        // Arrange
        address invalidDummyAddress = address(0);
        uint256 amountDummy = 10_000 ether;

        // Act
        vm.startPrank(user);
        vm.expectRevert(
            MySelfTokenERC20.MySelfTokenERC20__InValidAddress.selector
        );
        token.transfer(invalidDummyAddress, amountDummy);
        vm.stopPrank();
    }

    function testTransferCannotExceedLimit() public sendingTokenToUser {
        // Arrange
        uint256 amountMoreThanBalance = 100_001 ether;

        // Act
        vm.startPrank(user);
        vm.expectRevert(
            MySelfTokenERC20.MySelfTokenERC20__InSufficientBalance.selector
        );
        token.transfer(receiptient, amountMoreThanBalance);
        vm.stopPrank();
    }

    function testApprove() public {
        // Arrange
        uint256 amountApproving = 100_010 ether;

        // Act
        vm.startPrank(user);
        token.approve(receiptient, amountApproving);
        vm.stopPrank();

        // Assert
        uint256 approvedTokens = token.allowance(user, receiptient);
        assertEq(amountApproving, approvedTokens);
    }

    function testApproveCantWorkOnInvalidAddress() public {
        // Arrange
        uint256 amountApproving = 100_010 ether;
        address invalidAddress = address(0);

        // Act
        vm.startPrank(user);
        vm.expectRevert(
            MySelfTokenERC20.MySelfTokenERC20__InValidAddress.selector
        );
        token.approve(invalidAddress, amountApproving);
        vm.stopPrank();
    }

    function testTransferFromWorking() public sendingTokenToUser {
        // Arrange
        uint256 amountApproving = 10_000 ether;
        uint256 amountSending = 1_000 ether;
        address dummyAddressForTransfer = makeAddr("dummy");
        uint256 beforeAmountUser = token.balanceOf(user);
        uint256 beforeAmountDummyAddress = token.balanceOf(
            dummyAddressForTransfer
        );

        // Act
        vm.startPrank(user);
        token.approve(receiptient, amountApproving);
        uint256 allownaceBefore = token.allowance(user, receiptient);
        vm.stopPrank();

        // Assert
        vm.startPrank(receiptient);
        token.transferFrom(user, dummyAddressForTransfer, amountSending);
        uint256 afterAmountUser = token.balanceOf(user);
        uint256 afterAmountDummyAddress = token.balanceOf(
            dummyAddressForTransfer
        );
        uint256 allownaceAfter = token.allowance(user, receiptient);
        vm.stopPrank();

        assertEq(afterAmountUser, beforeAmountUser - amountSending);
        assertEq(
            afterAmountDummyAddress,
            beforeAmountDummyAddress + amountSending
        );
        assertEq(allownaceAfter, allownaceBefore - amountSending);
    }

    function testTransferFromCantWorkOnInvalidAddress() public sendingTokenToUser {
        // Arrange
        uint256 amountApproving = 10_000 ether;
        uint256 amountSending = 1_000 ether;
        address dummyAddressForTransfer = address(0);

        // Act
        vm.startPrank(user);
        token.approve(receiptient, amountApproving);
        vm.stopPrank();

        // Assert
        vm.startPrank(receiptient);
        vm.expectRevert(
            MySelfTokenERC20.MySelfTokenERC20__InValidAddress.selector
        );
        token.transferFrom(user, dummyAddressForTransfer, amountSending);
        vm.stopPrank();
    }

    function testTransferFromCantExceedLimitOfAllowance() public sendingTokenToUser {
        // Arrange
        uint256 amountApproving = 10_000 ether;
        uint256 amountSending = 10_001 ether;
        address dummyAddressForTransfer = makeAddr("dummy");

        // Act
        vm.startPrank(user);
        token.approve(receiptient, amountApproving);
        vm.stopPrank();

        // Assert
        vm.startPrank(receiptient);
        vm.expectRevert(
            MySelfTokenERC20.MySelfTokenERC20__SpendingLimitExceeded.selector
        );
        token.transferFrom(user, dummyAddressForTransfer, amountSending);
        vm.stopPrank();
    }

    function testTransferFromCantExceedLimitOfUser() public sendingTokenToUser {
        // Arrange
        uint256 amountApproving = type(uint256).max;
        uint256 amountSending = 100_001 ether;
        address dummyAddressForTransfer = makeAddr("dummy");

        // Act
        vm.startPrank(user);
        token.approve(receiptient, amountApproving);
        vm.stopPrank();

        // Assert
        vm.startPrank(receiptient);
        vm.expectRevert(
            MySelfTokenERC20.MySelfTokenERC20__InSufficientBalance.selector
        );
        token.transferFrom(user, dummyAddressForTransfer, amountSending);
        vm.stopPrank();
    }

    //////////////////////
    // Getters Function //
    /////////////////////
    function testTotalSupply() public view {
        assertEq(token.totalSupply(), token.balanceOf(owner));
    }

    function testBalanceOfDontWorkOnInvalidAddress() public {
        address invalid = address(0);
        vm.expectRevert(MySelfTokenERC20.MySelfTokenERC20__InValidAddress.selector);
        token.balanceOf(invalid);
    }
}
