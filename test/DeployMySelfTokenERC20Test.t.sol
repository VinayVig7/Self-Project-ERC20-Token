// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {MySelfTokenERC20} from "src/MySelfTokenERC20.sol";
import {DeployMySelfTokenERC20} from "script/DeployMySelfTokenERC20.s.sol";

contract MySelfTokenERC20Test is Test {
    /////////////////////
    // State Variables //
    ////////////////////
    MySelfTokenERC20 token;
    DeployMySelfTokenERC20 deployer;
    uint256 constant initialSupply = 10_000_000 ether;
    address owner = makeAddr("owner");

    ///////////////
    // Functions //
    //////////////
    function setUp() external {
        deployer = new DeployMySelfTokenERC20();
        token = deployer.deployMySelfTokenERC20();
    }

    function testScriptDeploysCorrectly() public view {
        assertEq(token.totalSupply(), 10_000_000 ether);
    }

    function testDeployerOwnsAllTokens() external view {
        // The deployer in this test is the test contract itself
        assertEq(token.balanceOf(address(deployer)), initialSupply);
    }

    function testTokenMetadata() external view {
        assertEq(token.name(), "MySelfToken");
        assertEq(token.symbol(), "MST");
        assertEq(token.decimals(), 18);
    }

    function testRunExecutesScript() external {
        token = deployer.run(); // Calls run(), which calls deployMySelfTokenERC20()
        assertEq(token.totalSupply(), 10_000_000 ether);
    }
}
