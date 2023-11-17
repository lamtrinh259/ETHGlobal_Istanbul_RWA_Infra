// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Marketplace} from "../src/Marketplace.sol";
import {Shop} from "../src/Shop.sol";
import {USDC} from "../src/mock/ERC20.sol";

contract MarketplaceTest is Test {
    Marketplace public marketplace;
    Shop public shop;
    USDC public usdc;
    address public owner;
    address public buyer;

    function setUp() public {
        owner = msg.sender;
        marketplace = new Marketplace(owner);
        shop = new Shop(owner);
        usdc = new USDC(owner);

        buyer = address(1);
        vm.deal(buyer, 100 ether);
    }

    function create_offer_with_eth() public {
        shop.mint(owner, "https://example.com/1");

        shop.setApprovalForAll(address(marketplace), true);

        marketplace.createOffer(
            1,
            Marketplace.PurchaseTokenInfo({
                // Set the price to 1 ether
                amount: 1 ether,
                // Set the price in ETH so the zero address
                tokenAddress: address(0)
            }),
            Marketplace.NFTInfo({
                // Get the address of the shop contract
                nftAddress: address(shop),
                // Create an offer for the newly created token
                tokenId: 1
            })
        );

        (
            address offerSeller,
            Marketplace.PurchaseTokenInfo memory offerTokenInfo,
            Marketplace.NFTInfo memory offerNftInfo
        ) = marketplace.offers(1);

        // Make sure the offer was created correctly
        assertEq(offerSeller, owner);
        assertEq(offerTokenInfo.amount, 1 ether);
        assertEq(offerTokenInfo.tokenAddress, address(0));
        assertEq(offerNftInfo.nftAddress, address(shop));
        assertEq(offerNftInfo.tokenId, 1);

        // The marketplace should now own the NFT of the seller
        assertEq(shop.ownerOf(1), address(marketplace));
    }

    function test_create_offer_with_eth() public {
        vm.startPrank(owner);

        create_offer_with_eth();

        vm.stopPrank();
    }

    function test_cancel_offer() public {
        vm.startPrank(owner);

        create_offer_with_eth();

        // Cancel the offer
        marketplace.cancelOffer(1);

        // The marketplace should no longer own the NFT of the seller
        // and the seller should have it back
        assertEq(shop.ownerOf(1), owner);

        // The offer should no longer exist
        (
            address offerSeller,
            Marketplace.PurchaseTokenInfo memory offerTokenInfo,
            Marketplace.NFTInfo memory offerNftInfo
        ) = marketplace.offers(1);
        assertEq(offerSeller, address(0));
        assertEq(offerTokenInfo.amount, 0);
        assertEq(offerTokenInfo.tokenAddress, address(0));
        assertEq(offerNftInfo.nftAddress, address(0));
        assertEq(offerNftInfo.tokenId, 0);

        vm.stopPrank();
    }

    function test_buy_with_eth() public {
        vm.startPrank(owner);

        create_offer_with_eth();

        vm.stopPrank();

        vm.startPrank(buyer);

        uint256 originalOwnerBalance = owner.balance;

        // Buy the offer
        marketplace.buy{value: 1 ether}(1);

        // The buyer should now own the NFT
        assertEq(shop.ownerOf(1), buyer);

        // The seller should have received the payment
        assertEq(owner.balance, originalOwnerBalance + 1 ether);

        // The offer should no longer exist
        (
            address offerSeller,
            Marketplace.PurchaseTokenInfo memory offerTokenInfo,
            Marketplace.NFTInfo memory offerNftInfo
        ) = marketplace.offers(1);
        assertEq(offerSeller, address(0));
        assertEq(offerTokenInfo.amount, 0);
        assertEq(offerTokenInfo.tokenAddress, address(0));
        assertEq(offerNftInfo.nftAddress, address(0));
        assertEq(offerNftInfo.tokenId, 0);

        vm.stopPrank();
    }

    // With ERC20 as purchase token

    function create_offer_with_usdc() public {
        shop.mint(owner, "https://example.com/1");

        shop.setApprovalForAll(address(marketplace), true);

        marketplace.createOffer(
            1,
            Marketplace.PurchaseTokenInfo({
                // Set the price to 5 USDC (assuming 18 decimals)
                amount: 5 ether,
                // Set the price in USDC
                tokenAddress: address(usdc)
            }),
            Marketplace.NFTInfo({
                // Get the address of the shop contract
                nftAddress: address(shop),
                // Create an offer for the newly created token
                tokenId: 1
            })
        );

        (
            address offerSeller,
            Marketplace.PurchaseTokenInfo memory offerTokenInfo,
            Marketplace.NFTInfo memory offerNftInfo
        ) = marketplace.offers(1);

        // Make sure the offer was created correctly
        assertEq(offerSeller, owner);
        assertEq(offerTokenInfo.amount, 5 ether);
        assertEq(offerTokenInfo.tokenAddress, address(usdc));
        assertEq(offerNftInfo.nftAddress, address(shop));
        assertEq(offerNftInfo.tokenId, 1);

        // The marketplace should now own the NFT of the seller
        assertEq(shop.ownerOf(1), address(marketplace));
    }

    function test_create_offer_with_usdc() public {
        vm.startPrank(owner);

        create_offer_with_usdc();

        vm.stopPrank();
    }

    function test_buy_with_usdc() public {
        vm.startPrank(owner);

        create_offer_with_usdc();

        usdc.mint(buyer, 100 ether);

        vm.stopPrank();

        vm.startPrank(buyer);

        uint256 originalOwnerBalance = usdc.balanceOf(owner);

        // Approve the marketplace to spend the buyer's USDC
        usdc.approve(address(marketplace), 5 ether);

        // Buy the offer
        marketplace.buy(1);

        // The buyer should now own the NFT
        assertEq(shop.ownerOf(1), buyer);

        // The seller should have received the payment
        assertEq(usdc.balanceOf(owner), originalOwnerBalance + 5 ether);

        // The offer should no longer exist
        (
            address offerSeller,
            Marketplace.PurchaseTokenInfo memory offerTokenInfo,
            Marketplace.NFTInfo memory offerNftInfo
        ) = marketplace.offers(1);
        assertEq(offerSeller, address(0));
        assertEq(offerTokenInfo.amount, 0);
        assertEq(offerTokenInfo.tokenAddress, address(0));
        assertEq(offerNftInfo.nftAddress, address(0));
        assertEq(offerNftInfo.tokenId, 0);

        vm.stopPrank();
    }
}
