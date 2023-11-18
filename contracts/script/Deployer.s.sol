// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Marketplace.sol";
import "../src/Shop.sol";

contract DeployerScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        //Marketplace marketplace = new Marketplace(msg.sender);
        //Shop shop = new Shop(msg.sender);

        vm.stopBroadcast();
    }
}
