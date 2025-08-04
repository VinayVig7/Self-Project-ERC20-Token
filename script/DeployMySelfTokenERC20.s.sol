// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {MySelfTokenERC20} from "src/MySelfTokenERC20.sol";

contract DeployMySelfTokenERC20 is Script {
    uint256 constant totalSupply = 10_000_000 ether;

    // This function is used in both tests and the deploy script
    function deployMySelfTokenERC20() public returns (MySelfTokenERC20) {
        return new MySelfTokenERC20(totalSupply);
    }

    // This function is only used when deploying to a real chain
    function run() public returns (MySelfTokenERC20){
        vm.startBroadcast();
        deployMySelfTokenERC20();
        vm.stopBroadcast();
        return deployMySelfTokenERC20();
    }
}
