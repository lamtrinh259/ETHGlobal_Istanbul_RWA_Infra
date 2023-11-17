// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Shop} from "../src/Shop.sol";

contract ShopTest is Test {
    Shop public shop;

    function setUp() public {
        shop = new Shop(msg.sender);
    }
}
