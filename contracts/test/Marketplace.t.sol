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
            Marketplace.TokenInfo({
                // Set the price to 1 ether
                amount: 1 ether,
                // Set the price in ETH so the zero address
                tokenAddress: address(0),
                // The fees will be set on the smart contract
                // so we can set it to zero
                fees: 0
            }),
            Marketplace.NFTInfo({
                // Get the address of the shop contract
                nftAddress: address(shop),
                // Create an offer for the newly created token
                tokenId: 1
            }),
            expiryDate
        );

        Marketplace.Offer memory offer = marketplace.getOffer(offerId);

        // Make sure the offer was created correctly
        assertEq(offer.seller, seller);
        // The fees and amount are stored separately and deduced from the price set
        // by the seller. The fees are 5% of the price set by the seller.
        assertEq(offer.tokenInfo.amount, 0.95 ether);
        assertEq(offer.tokenInfo.fees, 0.05 ether);
        assertEq(offer.tokenInfo.tokenAddress, address(0));
        assertEq(offer.nftInfo.nftAddress, address(shop));
        assertEq(offer.nftInfo.tokenId, 1);
        assertEq(offer.expiresAt, expiryDate);

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
        Marketplace.Offer memory offer = marketplace.getOffer(offerId);
        assertEq(offer.seller, address(0));
        assertEq(offer.tokenInfo.amount, 0);
        assertEq(offer.tokenInfo.tokenAddress, address(0));
        assertEq(offer.nftInfo.nftAddress, address(0));
        assertEq(offer.nftInfo.tokenId, 0);
        assertEq(offer.expiresAt, 0);

        vm.stopPrank();
    }

    function test_buy_with_eth() public {
        vm.startPrank(seller);

        uint256 offerId = create_offer_with_eth(0);

        vm.stopPrank();

        vm.startPrank(buyer);

        uint256 originalSellerBalance = seller.balance;
        uint256 originalMarketplaceOwnerBalance = marketplaceOwner.balance;

        Marketplace.Offer memory offer = marketplace.getOffer(offerId);

        uint256 price = offer.tokenInfo.amount + offer.tokenInfo.fees;
        assertEq(price, 1 ether);

        // Buy the offer
        marketplace.buy{value: price}(offerId);

        // The buyer should now own the NFT
        assertEq(shop.ownerOf(1), buyer);

        // The seller should have received the payment minus the 5% fees
        assertEq(seller.balance, originalSellerBalance + 0.95 ether);

        // The marketplace owner should have received the fee
        // 5% of 1 ETH = 0.05 ETH
        assertEq(
            marketplaceOwner.balance,
            originalMarketplaceOwnerBalance + 0.05 ether
        );

        // The offer should no longer exist
        offer = marketplace.getOffer(offerId);
        assertEq(offer.seller, address(0));
        assertEq(offer.tokenInfo.amount, 0);
        assertEq(offer.tokenInfo.tokenAddress, address(0));
        assertEq(offer.nftInfo.nftAddress, address(0));
        assertEq(offer.nftInfo.tokenId, 0);
        assertEq(offer.expiresAt, 0);

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

        Marketplace.Offer memory offer = marketplace.getOffer(offerId);

        uint256 price = offer.tokenInfo.amount + offer.tokenInfo.fees;
        assertEq(price, 1 ether);

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

        // The seller should have received the payment minus the 5% fees
        assertEq(seller.balance, originalSellerBalance + 0.95 ether);

        // The marketplace owner should have received the fee
        // 5% of 1 ETH = 0.05 ETH
        assertEq(
            marketplaceOwner.balance,
            originalMarketplaceOwnerBalance + 0.05 ether
        );

        // The offer should no longer exist
        offer = marketplace.getOffer(offerId);
        assertEq(offer.seller, address(0));
        assertEq(offer.tokenInfo.amount, 0);
        assertEq(offer.tokenInfo.tokenAddress, address(0));
        assertEq(offer.nftInfo.nftAddress, address(0));
        assertEq(offer.nftInfo.tokenId, 0);
        assertEq(offer.expiresAt, 0);

        vm.stopPrank();
    }

    // With ERC20 as purchase token

    function create_offer_with_usdc() public returns (uint256) {
        shop.mint(seller, "https://example.com/1");

        shop.setApprovalForAll(address(marketplace), true);

        uint256 offerId = marketplace.createOffer(
            Marketplace.TokenInfo({
                // Set the price to 5 USDC (assuming 18 decimals)
                amount: 5 ether,
                // Set the price in USDC
                tokenAddress: address(usdc),
                fees: 0
            }),
            Marketplace.NFTInfo({
                // Get the address of the shop contract
                nftAddress: address(shop),
                // Create an offer for the newly created token
                tokenId: 1
            }),
            0
        );

        Marketplace.Offer memory offer = marketplace.getOffer(offerId);

        // Make sure the offer was created correctly
        assertEq(offer.seller, seller);
        assertEq(offer.tokenInfo.amount, 4.75 ether);
        assertEq(offer.tokenInfo.fees, 0.25 ether);
        assertEq(offer.tokenInfo.tokenAddress, address(usdc));
        assertEq(offer.nftInfo.nftAddress, address(shop));
        assertEq(offer.nftInfo.tokenId, 1);
        assertEq(offer.expiresAt, 0);

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

        Marketplace.Offer memory offer = marketplace.getOffer(offerId);

        uint256 price = offer.tokenInfo.amount + offer.tokenInfo.fees;
        assertEq(offer.tokenInfo.amount, 4.75 ether);
        assertEq(offer.tokenInfo.fees, 0.25 ether);
        assertEq(price, 5 ether);

        // Approve the marketplace to spend the buyer's USDC
        usdc.approve(address(marketplace), 5 ether);

        // Buy the offer
        marketplace.buy(offerId);

        // The buyer should now own the NFT
        assertEq(shop.ownerOf(1), buyer);

        // The seller should have received the payment minues the 5% fees
        assertEq(usdc.balanceOf(seller), originalSellerBalance + 4.75 ether);

        // The marketplace owner should have received the fee
        // 5% of 5 USDC = 0.25 USDC
        assertEq(
            usdc.balanceOf(marketplaceOwner),
            originalMarketplaceOwnerBalance + 0.25 ether
        );

        // The offer should no longer exist
        offer = marketplace.getOffer(offerId);
        assertEq(offer.seller, address(0));
        assertEq(offer.tokenInfo.amount, 0);
        assertEq(offer.tokenInfo.tokenAddress, address(0));
        assertEq(offer.nftInfo.nftAddress, address(0));
        assertEq(offer.nftInfo.tokenId, 0);
        assertEq(offer.expiresAt, 0);

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

    // Bids

    function create_bid_with_eth() public returns (uint256) {
        vm.startPrank(seller);

        uint256 tokenId = 1;

        shop.mint(seller, "https://example.com/1");

        shop.setApprovalForAll(address(marketplace), true);

        vm.stopPrank();

        vm.startPrank(buyer);

        uint256 bidId = marketplace.placeBid{value: 1 ether}(
            Marketplace.TokenInfo({
                // Set the price to 1 ether
                amount: 1 ether,
                // Set the price in ETH so the zero address
                tokenAddress: address(0),
                // The fees will be set on the smart contract
                // so we can set it to zero
                fees: 0
            }),
            Marketplace.NFTInfo({
                // Get the address of the shop contract
                nftAddress: address(shop),
                // Create an offer for the newly created token
                tokenId: tokenId
            }),
            0
        );

        Marketplace.Bid memory bid = marketplace.getBid(bidId);
        assertEq(bid.bidder, buyer);
        assertEq(bid.tokenInfo.amount, 0.95 ether);
        assertEq(bid.tokenInfo.fees, 0.05 ether);
        assertEq(bid.tokenInfo.tokenAddress, address(0));
        assertEq(bid.nftInfo.nftAddress, address(shop));
        assertEq(bid.nftInfo.tokenId, tokenId);
        assertEq(bid.expiresAt, 0);

        Marketplace.Bid[] memory bids = marketplace.getBidsForNFT(tokenId);
        assertEq(bids.length, 1);
        assertEq(bids[0].bidder, buyer);
        assertEq(bids[0].tokenInfo.amount, 0.95 ether);
        assertEq(bids[0].tokenInfo.fees, 0.05 ether);
        assertEq(bids[0].tokenInfo.tokenAddress, address(0));
        assertEq(bids[0].nftInfo.nftAddress, address(shop));
        assertEq(bids[0].nftInfo.tokenId, tokenId);
        assertEq(bids[0].expiresAt, 0);

        // The marketplace should now have received the tokens of the buyer
        assertEq(address(marketplace).balance, 1 ether);

        vm.stopPrank();

        return bidId;
    }

    function test_place_bid_with_eth() public {
        create_bid_with_eth();
    }

    function test_cancel_bid() public {
        uint256 bidId = create_bid_with_eth();

        vm.startPrank(buyer);

        // Cancel the bid
        marketplace.cancelBid(bidId);

        // The marketplace should no longer have the tokens of the buyer
        assertEq(address(marketplace).balance, 0);

        // The bid should no longer exist
        Marketplace.Bid memory bid = marketplace.getBid(bidId);
        assertEq(bid.bidder, address(0));
        assertEq(bid.tokenInfo.amount, 0);
        assertEq(bid.tokenInfo.tokenAddress, address(0));
        assertEq(bid.nftInfo.nftAddress, address(0));
        assertEq(bid.nftInfo.tokenId, 0);
        assertEq(bid.expiresAt, 0);

        // The bid should no longer exist in the list of bids for the NFT
        Marketplace.Bid[] memory bids = marketplace.getBidsForNFT(1);
        assertEq(bids.length, 0);

        vm.stopPrank();
    }

    function test_accept_bid_with_eth() public {
        uint256 bidId = create_bid_with_eth();

        vm.startPrank(seller);

        uint256 originalSellerBalance = seller.balance;
        uint256 originalMarketplaceOwnerBalance = marketplaceOwner.balance;

        // Accept the bid
        marketplace.acceptBid(bidId);

        // The buyer should now own the NFT
        assertEq(shop.ownerOf(1), buyer);

        // The seller should have received the payment
        assertEq(seller.balance, originalSellerBalance + 0.95 ether);

        // The marketplace owner should have received the fee
        // 5% of 1 ETH = 0.05 ETH
        assertEq(
            marketplaceOwner.balance,
            originalMarketplaceOwnerBalance + 0.05 ether
        );

        // The bid should no longer exist
        Marketplace.Bid memory bid = marketplace.getBid(bidId);
        assertEq(bid.bidder, address(0));
        assertEq(bid.tokenInfo.amount, 0);
        assertEq(bid.tokenInfo.tokenAddress, address(0));
        assertEq(bid.nftInfo.nftAddress, address(0));
        assertEq(bid.nftInfo.tokenId, 0);
        assertEq(bid.expiresAt, 0);

        // The bid should no longer exist in the list of bids for the NFT
        Marketplace.Bid[] memory bids = marketplace.getBidsForNFT(1);
        assertEq(bids.length, 0);

        vm.stopPrank();
    }

    // Price feeds

    function test_get_eth_to_usd() public {
        vm.createSelectFork(vm.envString("POLYGON_RPC_URL"), 50086102);
        marketplace = new Marketplace(marketplaceOwner);

        assertEq(block.number, 50086102);

        (int224 value, uint256 timestamp) = marketplace.getETHtoUSD();
        assertEq(value, 1941312063585853600000);
        assertEq(timestamp, 1700296712);
    }

    function test_get_usdc_to_usd() public {
        vm.createSelectFork(vm.envString("BASE_GOERLI_RPC_URL"), 12564075);
        marketplace = new Marketplace(marketplaceOwner);

        assertEq(block.number, 12564075);

        (int224 value, uint256 timestamp) = marketplace.getUSDCtoUSD();
        assertEq(value, 999750000000000000);
        assertEq(timestamp, 1700252783);
    }
}
