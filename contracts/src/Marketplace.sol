// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract Marketplace is Ownable, IERC721Receiver {
    using Address for address payable;

    // Structs
    struct TokenInfo {
        uint256 amount;
        uint256 fees;
        address tokenAddress;
    }

    struct NFTInfo {
        address nftAddress;
        uint256 tokenId;
    }

    struct Offer {
        address seller;
        TokenInfo tokenInfo;
        NFTInfo nftInfo;
        uint256 expiresAt;
    }

    struct Bid {
        address bidder;
        TokenInfo tokenInfo;
        NFTInfo nftInfo;
        uint256 expiresAt;
    }

    // Mappings

    // Mapping from offer ID to offer details
    mapping(uint256 => Offer) private offers;
    // Mapping from NFT ID to offer ID
    // Helps to keep better track of the NFT
    // and keep one offer per NFT at a tinme
    mapping(uint256 => uint256) private nftToOffer;

    // Mapping from bid ID to bid details
    mapping(uint256 => Bid) private bids;
    // Mapping from NFT ID to bid IDs
    mapping(uint256 => uint256[]) private nftToBids;

    // Other variables

    // The fee percentage that the marketplace takes from each sale
    // 2 decimals of precision, so 500 = 5%
    uint256 public marketplaceFee = 500;

    // Events
    event OfferCreated(
        uint256 indexed offerId,
        address indexed seller,
        TokenInfo tokenInfo,
        NFTInfo nftInfo
    );
    event OfferCancelled(uint256 indexed offerId);
    event PurchaseCompleted(
        uint256 indexed offerId,
        address indexed buyer,
        address indexed seller
    );
    event BidPlaced(
        uint256 indexed bidId,
        address indexed bidder,
        TokenInfo tokenInfo,
        NFTInfo nftInfo
    );
    event BidCancelled(uint256 indexed bidId);
    event BidAccepted(
        uint256 indexed bidId,
        address indexed bidder,
        address indexed seller
    );

    constructor(address initialOwner) Ownable(initialOwner) {}

    // Seller functions

    function createOffer(
        TokenInfo memory tokenInfo,
        NFTInfo memory nftInfo,
        uint256 expiresAt
    ) external returns (uint256) {
        address sender = msg.sender;
        // Check there is no existing offer for this NFT
        // Technically the offerId could be 0, but the likelihood is negligible
        require(nftToOffer[nftInfo.tokenId] == 0, "NFT already on sale");
        // Generate the offer ID by hashing the offer details
        uint256 offerId = uint256(
            keccak256(
                abi.encodePacked(
                    sender,
                    tokenInfo.amount,
                    tokenInfo.tokenAddress,
                    nftInfo.nftAddress,
                    nftInfo.tokenId,
                    expiresAt
                )
            )
        );

        // Check that the offer doesn't already exist
        require(offers[offerId].seller == address(0), "Offer already exists");
        // Check that the token address is valid
        require(nftInfo.nftAddress != address(0), "Invalid NFT address");

        IERC721 nftContract = IERC721(nftInfo.nftAddress);
        // Check that the sender (i.e. seller) actually owns the NFT
        require(
            nftContract.ownerOf(nftInfo.tokenId) == sender,
            "Not NFT owner"
        );
        // Check that this contract can transfer the NFT out of the seller's account
        require(
            nftContract.isApprovedForAll(sender, address(this)),
            "Not approved for transfer"
        );

        // Create the offer
        offers[offerId] = Offer({
            seller: sender,
            tokenInfo: TokenInfo({
                amount: (tokenInfo.amount * (10000 - marketplaceFee)) / 10000,
                fees: (tokenInfo.amount * marketplaceFee) / 10000,
                tokenAddress: tokenInfo.tokenAddress
            }),
            nftInfo: nftInfo,
            expiresAt: expiresAt
        });
        nftToOffer[nftInfo.tokenId] = offerId;

        // Transfer the NFT from the seller's account to this contract
        nftContract.safeTransferFrom(sender, address(this), nftInfo.tokenId);

        emit OfferCreated(offerId, sender, tokenInfo, nftInfo);

        return offerId;
    }

    function cancelOffer(uint256 offerId) external {
        address seller = msg.sender;
        Offer storage offer = offers[offerId];
        uint256 tokenId = offer.nftInfo.tokenId;

        // Check that the offer exists
        require(offer.seller != address(0), "Offer does not exist");
        // Check that the sender is the seller
        require(offer.seller == seller, "Not seller");

        IERC721 nftContract = IERC721(offer.nftInfo.nftAddress);

        // Delete the offer
        delete offers[offerId];
        delete nftToOffer[tokenId];

        // Transfer the NFT from this contract back to the seller's account
        nftContract.safeTransferFrom(address(this), seller, tokenId);

        emit OfferCancelled(offerId);
    }

    function acceptBid(uint256 bidId) external {
        address seller = msg.sender;
        Bid memory bid = bids[bidId];

        // Check that the bid exists
        require(bid.bidder != address(0), "Bid does not exist");

        // Check that the bid hasn't expired
        // If the expiresAt is 0 then the offer never expires
        require(
            bid.expiresAt == 0 || block.timestamp < bid.expiresAt,
            "Bid expired"
        );

        IERC721 nftContract = IERC721(bid.nftInfo.nftAddress);

        // Check that the owner of the NFT is the sender
        require(
            nftContract.ownerOf(bid.nftInfo.tokenId) == seller,
            "Not NFT owner"
        );
        // Check that this contract is approved to make the
        // transfer of the NFT on behalf of the seller
        require(
            nftContract.isApprovedForAll(seller, address(this)),
            "Not approved for transfer"
        );

        // Delete the bid
        delete bids[bidId];

        // Ensure to delete any offer active for this NFT
        delete offers[nftToOffer[bid.nftInfo.tokenId]];
        delete nftToOffer[bid.nftInfo.tokenId];

        // Find and delete the bid ID from the list of bids for this NFT
        uint256[] storage bidsForNFT = nftToBids[bid.nftInfo.tokenId];
        for (uint256 i = 0; i < bidsForNFT.length; i++) {
            if (bidsForNFT[i] == bidId) {
                bidsForNFT[i] = bidsForNFT[bidsForNFT.length - 1];
                bidsForNFT.pop();
                break;
            }
        }

        // Transfer the NFT from this seller to the bidder's account
        nftContract.safeTransferFrom(seller, bid.bidder, bid.nftInfo.tokenId);

        if (bid.tokenInfo.tokenAddress != address(0)) {
            IERC20 purchaseToken = IERC20(bid.tokenInfo.tokenAddress);
            // Transfer the ERC20 tokens from this contract to the seller's account
            purchaseToken.transfer(seller, bid.tokenInfo.amount);
            // Send the fees to the owner of the marketplace
            purchaseToken.transfer(owner(), bid.tokenInfo.fees);
        } else {
            // Transfer the native token (such as ETH on Ethereum) from this contract to the seller's account
            payable(seller).sendValue(bid.tokenInfo.amount);
            // Send the fees to the owner of the marketplace
            payable(owner()).sendValue(bid.tokenInfo.fees);
        }

        emit BidAccepted(bidId, bid.bidder, seller);
    }

    // Buyer functions

    function buy(uint256 offerId) external payable {
        address buyer = msg.sender;
        Offer memory offer = offers[offerId];

        // Check that the offer exists
        require(offer.seller != address(0), "Offer does not exist");
        // Check that the sender is not the seller
        require(offer.seller != buyer, "Seller cannot buy own offer");
        // Check that the offer hasn't expired
        // If the expiresAt is 0 then the offer never expires
        require(
            offer.expiresAt == 0 || block.timestamp < offer.expiresAt,
            "Offer expired"
        );

        IERC721 nftContract = IERC721(offer.nftInfo.nftAddress);

        uint256 totalAmount = offer.tokenInfo.amount + offer.tokenInfo.fees;
        // If the tokenAddress of the purchase token is defined then the purchase
        // is supposed to be made using this token...
        if (offer.tokenInfo.tokenAddress != address(0)) {
            // Transfer the purchase token from the buyer's account to the seller's account
            IERC20 purchaseToken = IERC20(offer.tokenInfo.tokenAddress);
            // Check that the smart contract can transfer the token on behalf of the buyer
            require(
                purchaseToken.allowance(buyer, address(this)) >= totalAmount,
                "Not enough tokens approved for transfer"
            );

            // Transfer the ERC20 tokens from the buyer to the seller
            // according to the price set
            purchaseToken.transferFrom(
                buyer,
                offer.seller,
                offer.tokenInfo.amount
            );

            // Transfer the fees to the owner of the marketplace
            purchaseToken.transferFrom(buyer, owner(), offer.tokenInfo.fees);
        } else {
            // ...otherwise we use the native token (such as ETH on Ethereum)
            require(msg.value == totalAmount, "Wrong price");

            // Send the native token to the seller
            payable(offer.seller).sendValue(offer.tokenInfo.amount);
            // Send the fees to the owner of the marketplace
            payable(owner()).sendValue(offer.tokenInfo.fees);
        }

        // Delete the offer
        delete offers[offerId];
        delete nftToOffer[offer.nftInfo.tokenId];

        // Transfer the NFT from this contract to the buyer's account
        nftContract.safeTransferFrom(
            address(this),
            buyer,
            offer.nftInfo.tokenId
        );

        emit PurchaseCompleted(offerId, buyer, offer.seller);
    }

    function placeBid(
        TokenInfo memory tokenInfo,
        NFTInfo memory nftInfo,
        uint256 expiresAt
    ) external payable returns (uint256) {
        address bidder = msg.sender;
        // Generate the bid ID by hashing the bid details
        uint256 bidId = uint256(
            keccak256(
                abi.encodePacked(
                    bidder,
                    tokenInfo.amount,
                    tokenInfo.tokenAddress,
                    nftInfo.nftAddress,
                    nftInfo.tokenId,
                    expiresAt
                )
            )
        );

        // Check that the bid doesn't already exist
        require(bids[bidId].bidder == address(0), "Bid already exists");
        // Check that the token address is valid
        require(nftInfo.nftAddress != address(0), "Invalid NFT address");

        IERC721 nftContract = IERC721(nftInfo.nftAddress);
        // Check that the sender (i.e. bidder) doesn't already own the NFT
        require(
            nftContract.ownerOf(nftInfo.tokenId) != bidder,
            "Not NFT owner"
        );

        // Create the bid
        bids[bidId] = Bid({
            bidder: bidder,
            tokenInfo: TokenInfo({
                // Set the fees when the bid is created (in case the fees changes later)
                amount: (tokenInfo.amount * (10000 - marketplaceFee)) / 10000,
                fees: (tokenInfo.amount * marketplaceFee) / 10000,
                tokenAddress: tokenInfo.tokenAddress
            }),
            nftInfo: nftInfo,
            expiresAt: expiresAt
        });
        nftToBids[nftInfo.tokenId].push(bidId);

        if (tokenInfo.tokenAddress != address(0)) {
            // Transfer the ERC20 tokens from the bidder to this contract
            // according to the price set
            IERC20 purchaseToken = IERC20(tokenInfo.tokenAddress);
            // Check that the smart contract can transfer the token on behalf of the bidder
            require(
                purchaseToken.allowance(bidder, address(this)) >=
                    tokenInfo.amount,
                "Not enough tokens approved for transfer"
            );

            purchaseToken.transferFrom(bidder, address(this), tokenInfo.amount);
        } else {
            // Transfer the native token (such as ETH on Ethereum) from the bidder to this contract
            // according to the price set
            require(msg.value == tokenInfo.amount, "Wrong price");
        }

        emit BidPlaced(bidId, bidder, tokenInfo, nftInfo);

        return bidId;
    }

    function cancelBid(uint256 bidId) external {
        address bidder = msg.sender;
        Bid memory bid = bids[bidId];

        // Check that the bid exists
        require(bid.bidder != address(0), "Bid does not exist");
        // Check that the sender is the bidder
        require(bid.bidder == bidder, "Not bidder");

        // Delete the bid
        delete bids[bidId];
        // Find and delete the bid ID from the list of bids for this NFT
        uint256[] storage bidsForNFT = nftToBids[bid.nftInfo.tokenId];
        for (uint256 i = 0; i < bidsForNFT.length; i++) {
            if (bidsForNFT[i] == bidId) {
                bidsForNFT[i] = bidsForNFT[bidsForNFT.length - 1];
                bidsForNFT.pop();
                break;
            }
        }

        // Transfer the ERC20 tokens from this contract back to the bidder's account
        if (bid.tokenInfo.tokenAddress != address(0)) {
            IERC20 purchaseToken = IERC20(bid.tokenInfo.tokenAddress);
            purchaseToken.transfer(
                bidder,
                bid.tokenInfo.amount + bid.tokenInfo.fees
            );
        } else {
            // Transfer the native token (such as ETH on Ethereum) from this contract back to the bidder's account
            payable(bidder).sendValue(
                bid.tokenInfo.amount + bid.tokenInfo.fees
            );
        }

        emit BidCancelled(bidId);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    // Admin functions

    function setMarketplaceFee(uint256 fee) external onlyOwner {
        require(fee <= 10000, "Fee cannot be greater than 100%");
        marketplaceFee = fee;
    }

    // Read functions

    function getNFTOffer(uint256 tokenId) external view returns (Offer memory) {
        uint256 offerId = nftToOffer[tokenId];
        return offers[offerId];
    }

    function getOffer(uint256 offerId) external view returns (Offer memory) {
        return offers[offerId];
    }

    function getBid(uint256 bidId) external view returns (Bid memory) {
        return bids[bidId];
    }

    function getBidsForNFT(
        uint256 tokenId
    ) external view returns (Bid[] memory) {
        uint256[] memory bidIds = nftToBids[tokenId];
        Bid[] memory bidsForNFT = new Bid[](bidIds.length);
        for (uint256 i = 0; i < bidIds.length; i++) {
            bidsForNFT[i] = bids[bidIds[i]];
        }
        return bidsForNFT;
    }
}
