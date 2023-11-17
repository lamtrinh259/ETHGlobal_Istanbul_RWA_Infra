// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Shop} from "../src/Shop.sol";

contract ShopTest is Test {
    Shop public shop;
    address public owner;

    function setUp() public {
        owner = msg.sender;
        shop = new Shop(owner);
    }

    function test_mint() public {
        vm.startPrank(owner);

        shop.mint(owner, "https://example.com/1");
        assertEq(shop.balanceOf(owner), 1);
        assertEq(shop.ownerOf(1), owner);
        assertEq(shop.tokenURI(1), "https://example.com/1");

        vm.stopPrank();
    }

    function test_multiple_mints() public {
        vm.startPrank(owner);

        shop.mint(owner, "https://example.com/1");
        assertEq(shop.balanceOf(owner), 1);
        assertEq(shop.ownerOf(1), owner);
        assertEq(shop.tokenURI(1), "https://example.com/1");

        shop.mint(owner, "https://example.com/2");
        assertEq(shop.balanceOf(owner), 2);
        assertEq(shop.ownerOf(2), owner);
        assertEq(shop.tokenURI(2), "https://example.com/2");

        vm.stopPrank();
    }

    function test_cannot_mint_if_not_owner() public {
        vm.startPrank(address(1));
        vm.expectRevert();
        shop.mint(owner, "https://example.com/1");
    }

    function test_change_token_uri() public {
        vm.startPrank(owner);

        shop.mint(owner, "https://example.com/1");
        assertEq(shop.balanceOf(owner), 1);
        assertEq(shop.ownerOf(1), owner);
        assertEq(shop.tokenURI(1), "https://example.com/1");

        shop.setTokenUri(1, "https://example.com/2");
        assertEq(shop.tokenURI(1), "https://example.com/2");

        vm.stopPrank();
    }
}
