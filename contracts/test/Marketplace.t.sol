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
    address public marketplaceOwner;
    address public seller;
    address public buyer;

    function setUp() public {
        marketplaceOwner = msg.sender;
        buyer = address(1);
        seller = address(2);

        marketplace = new Marketplace(marketplaceOwner);
        shop = new Shop(seller);
        usdc = new USDC(marketplaceOwner);

        vm.deal(buyer, 100 ether);
    }

    function create_offer_with_eth(
        uint256 expiryDate
    ) public returns (uint256) {
        shop.mint(seller, "https://example.com/1");

        shop.setApprovalForAll(address(marketplace), true);

        uint256 offerId = marketplace.createOffer(
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
            }),
            expiryDate
        );

        (
            address offerSeller,
            Marketplace.PurchaseTokenInfo memory offerTokenInfo,
            Marketplace.NFTInfo memory offerNftInfo,
            uint256 offerExpiresAt
        ) = marketplace.offers(offerId);

        // Make sure the offer was created correctly
        assertEq(offerSeller, seller);
        assertEq(offerTokenInfo.amount, 1 ether);
        assertEq(offerTokenInfo.tokenAddress, address(0));
        assertEq(offerNftInfo.nftAddress, address(shop));
        assertEq(offerNftInfo.tokenId, 1);
        assertEq(offerExpiresAt, expiryDate);

        // The marketplace should now own the NFT of the seller
        assertEq(shop.ownerOf(1), address(marketplace));

        return offerId;
    }

    function test_create_offer_with_eth() public {
        vm.startPrank(seller);

        create_offer_with_eth(0);

        vm.stopPrank();
    }

    function test_cancel_offer() public {
        vm.startPrank(seller);

        uint256 offerId = create_offer_with_eth(0);

        // Cancel the offer
        marketplace.cancelOffer(offerId);

        // The marketplace should no longer own the NFT of the seller
        // and the seller should have it back
        assertEq(shop.ownerOf(1), seller);

        // The offer should no longer exist
        (
            address offerSeller,
            Marketplace.PurchaseTokenInfo memory offerTokenInfo,
            Marketplace.NFTInfo memory offerNftInfo,
            uint256 offerExpiresAt
        ) = marketplace.offers(offerId);
        assertEq(offerSeller, address(0));
        assertEq(offerTokenInfo.amount, 0);
        assertEq(offerTokenInfo.tokenAddress, address(0));
        assertEq(offerNftInfo.nftAddress, address(0));
        assertEq(offerNftInfo.tokenId, 0);
        assertEq(offerExpiresAt, 0);

        vm.stopPrank();
    }

    function test_buy_with_eth() public {
        vm.startPrank(seller);

        uint256 offerId = create_offer_with_eth(0);

        vm.stopPrank();

        vm.startPrank(buyer);

        uint256 originalSellerBalance = seller.balance;
        uint256 originalMarketplaceOwnerBalance = marketplaceOwner.balance;

        uint256 price = marketplace.getTotalPriceForOffer(offerId);

        assertEq(price, 1.05 ether);

        // Buy the offer
        marketplace.buy{value: price}(offerId);

        // The buyer should now own the NFT
        assertEq(shop.ownerOf(1), buyer);

        // The seller should have received the payment
        assertEq(seller.balance, originalSellerBalance + 1 ether);

        // The marketplace owner should have received the fee
        // 5% of 1 ETH = 0.05 ETH
        assertEq(
            marketplaceOwner.balance,
            originalMarketplaceOwnerBalance + 0.05 ether
        );

        // The offer should no longer exist
        (
            address offerSeller,
            Marketplace.PurchaseTokenInfo memory offerTokenInfo,
            Marketplace.NFTInfo memory offerNftInfo,
            uint256 offerExpiresAt
        ) = marketplace.offers(offerId);
        assertEq(offerSeller, address(0));
        assertEq(offerTokenInfo.amount, 0);
        assertEq(offerTokenInfo.tokenAddress, address(0));
        assertEq(offerNftInfo.nftAddress, address(0));
        assertEq(offerNftInfo.tokenId, 0);
        assertEq(offerExpiresAt, 0);

        vm.stopPrank();
    }

    function test_buy_with_expiry() public {
        vm.startPrank(seller);

        uint256 offerId = create_offer_with_eth(block.timestamp + 100);

        vm.stopPrank();

        vm.startPrank(buyer);

        // Warp the time to 101 seconds in the future
        // Just one second after the expiry date
        vm.warp(block.timestamp + 101);

        uint256 price = marketplace.getTotalPriceForOffer(offerId);

        assertEq(price, 1.05 ether);

        vm.expectRevert();
        // Buy the offer but will fail since the offer expired
        marketplace.buy{value: price}(offerId);

        // Bring the time back to 2 seconds before
        // just one second before the expiry date
        vm.warp(block.timestamp - 2);

        uint256 originalSellerBalance = seller.balance;
        uint256 originalMarketplaceOwnerBalance = marketplaceOwner.balance;

        // Buy the offer and will succeed this time as we are just
        // before the expiry date
        marketplace.buy{value: price}(offerId);

        // The buyer should now own the NFT
        assertEq(shop.ownerOf(1), buyer);

        // The seller should have received the payment
        assertEq(seller.balance, originalSellerBalance + 1 ether);

        // The marketplace owner should have received the fee
        // 5% of 1 ETH = 0.05 ETH
        assertEq(
            marketplaceOwner.balance,
            originalMarketplaceOwnerBalance + 0.05 ether
        );

        // The offer should no longer exist
        (
            address offerSeller,
            Marketplace.PurchaseTokenInfo memory offerTokenInfo,
            Marketplace.NFTInfo memory offerNftInfo,
            uint256 offerExpiresAt
        ) = marketplace.offers(offerId);
        assertEq(offerSeller, address(0));
        assertEq(offerTokenInfo.amount, 0);
        assertEq(offerTokenInfo.tokenAddress, address(0));
        assertEq(offerNftInfo.nftAddress, address(0));
        assertEq(offerNftInfo.tokenId, 0);
        assertEq(offerExpiresAt, 0);

        vm.stopPrank();
    }

    // With ERC20 as purchase token

    function create_offer_with_usdc() public returns (uint256) {
        shop.mint(seller, "https://example.com/1");

        shop.setApprovalForAll(address(marketplace), true);

        uint256 offerId = marketplace.createOffer(
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
            }),
            0
        );

        (
            address offerSeller,
            Marketplace.PurchaseTokenInfo memory offerTokenInfo,
            Marketplace.NFTInfo memory offerNftInfo,
            uint256 offerExpiresAt
        ) = marketplace.offers(offerId);

        // Make sure the offer was created correctly
        assertEq(offerSeller, seller);
        assertEq(offerTokenInfo.amount, 5 ether);
        assertEq(offerTokenInfo.tokenAddress, address(usdc));
        assertEq(offerNftInfo.nftAddress, address(shop));
        assertEq(offerNftInfo.tokenId, 1);
        assertEq(offerExpiresAt, 0);

        // The marketplace should now own the NFT of the seller
        assertEq(shop.ownerOf(1), address(marketplace));

        return offerId;
    }

    function test_create_offer_with_usdc() public {
        vm.startPrank(seller);

        create_offer_with_usdc();

        vm.stopPrank();
    }

    function test_buy_with_usdc() public {
        vm.startPrank(marketplaceOwner);

        usdc.mint(buyer, 100 ether);

        vm.stopPrank();

        vm.startPrank(seller);

        uint256 offerId = create_offer_with_usdc();

        vm.stopPrank();

        vm.startPrank(buyer);

        uint256 originalSellerBalance = usdc.balanceOf(seller);
        uint256 originalMarketplaceOwnerBalance = usdc.balanceOf(
            marketplaceOwner
        );

        uint256 price = marketplace.getTotalPriceForOffer(offerId);

        // Approve the marketplace to spend the buyer's USDC
        usdc.approve(address(marketplace), price);

        // Buy the offer
        marketplace.buy(offerId);

        // The buyer should now own the NFT
        assertEq(shop.ownerOf(1), buyer);

        // The seller should have received the payment
        assertEq(usdc.balanceOf(seller), originalSellerBalance + 5 ether);

        // The marketplace owner should have received the fee
        // 5% of 5 USDC = 0.25 USDC
        assertEq(
            usdc.balanceOf(marketplaceOwner),
            originalMarketplaceOwnerBalance + 0.25 ether
        );

        // The offer should no longer exist
        (
            address offerSeller,
            Marketplace.PurchaseTokenInfo memory offerTokenInfo,
            Marketplace.NFTInfo memory offerNftInfo,
            uint256 offerExpiresAt
        ) = marketplace.offers(offerId);
        assertEq(offerSeller, address(0));
        assertEq(offerTokenInfo.amount, 0);
        assertEq(offerTokenInfo.tokenAddress, address(0));
        assertEq(offerNftInfo.nftAddress, address(0));
        assertEq(offerNftInfo.tokenId, 0);
        assertEq(offerExpiresAt, 0);

        vm.stopPrank();
    }

    // Admin functions

    function test_set_marketplace_fee() public {
        vm.startPrank(marketplaceOwner);

        assertEq(marketplace.marketplaceFee(), 500);

        marketplace.setMarketplaceFee(1000);

        assertEq(marketplace.marketplaceFee(), 1000);

        vm.stopPrank();
    }

    function test_cannot_set_marketplace_fee_if_not_owner() public {
        vm.startPrank(address(1));
        vm.expectRevert();
        marketplace.setMarketplaceFee(1000);
    }
}
