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
    struct PurchaseTokenInfo {
        uint256 amount;
        address tokenAddress;
    }

    struct NFTInfo {
        address nftAddress;
        uint256 tokenId;
    }

    struct Offer {
        address seller;
        PurchaseTokenInfo tokenInfo;
        NFTInfo nftInfo;
        uint256 expiresAt;
    }

    // Mappings
    mapping(uint256 => Offer) public offers;

    // Other variables

    // The fee percentage that the marketplace takes from each sale
    // 2 decimals of precision, so 500 = 5%
    uint256 public marketplaceFee = 500;

    // Events
    event OfferCreated(
        uint256 indexed offerId,
        address indexed seller,
        PurchaseTokenInfo tokenInfo,
        NFTInfo nftInfo
    );
    event OfferCancelled(uint256 indexed offerId);
    event PurchaseCompleted(
        uint256 indexed offerId,
        address indexed buyer,
        address indexed seller
    );

    constructor(address initialOwner) Ownable(initialOwner) {}

    function createOffer(
        PurchaseTokenInfo memory tokenInfo,
        NFTInfo memory nftInfo,
        uint256 expiresAt
    ) external returns (uint256) {
        // Generate the offer ID by hashing the offer details
        uint256 offerId = uint256(
            keccak256(
                abi.encodePacked(
                    msg.sender,
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

        IERC721 nft = IERC721(nftInfo.nftAddress);
        // Check that the sender (i.e. seller) actually owns the NFT
        require(nft.ownerOf(nftInfo.tokenId) == msg.sender, "Not NFT owner");
        // Check that this contract can transfer the NFT out of the seller's account
        require(
            nft.isApprovedForAll(msg.sender, address(this)),
            "Not approved for transfer"
        );

        // Create the offer
        offers[offerId] = Offer({
            seller: msg.sender,
            tokenInfo: tokenInfo,
            nftInfo: nftInfo,
            expiresAt: expiresAt
        });

        // Transfer the NFT from the seller's account to this contract
        nft.safeTransferFrom(msg.sender, address(this), nftInfo.tokenId);

        emit OfferCreated(offerId, msg.sender, tokenInfo, nftInfo);

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

        IERC721 nft = IERC721(offer.nftInfo.nftAddress);

        // Delete the offer
        delete offers[offerId];

        // Transfer the NFT from this contract back to the seller's account
        nft.safeTransferFrom(address(this), seller, tokenId);

        emit OfferCancelled(offerId);
    }

    function buy(uint256 offerId) external payable {
        address buyer = msg.sender;
        Offer storage offer = offers[offerId];
        address seller = offer.seller;
        uint256 tokenId = offer.nftInfo.tokenId;

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

        IERC721 nft = IERC721(offer.nftInfo.nftAddress);

        uint256 totalAmount = (offer.tokenInfo.amount *
            (10000 + marketplaceFee)) / 10000;
        uint256 fees = totalAmount - offer.tokenInfo.amount;
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
            purchaseToken.transferFrom(buyer, owner(), fees);
        } else {
            // ...otherwise we use the native token (such as ETH on Ethereum)
            require(msg.value == totalAmount, "Wrong price");

            // Send the native token to the seller
            payable(seller).sendValue(offer.tokenInfo.amount);
            // Send the fees to the owner of the marketplace
            payable(owner()).sendValue(fees);
        }

        // Delete the offer
        delete offers[offerId];

        // Transfer the NFT from this contract to the buyer's account
        nft.safeTransferFrom(address(this), buyer, tokenId);

        emit PurchaseCompleted(offerId, buyer, seller);
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

    function getTotalPriceForOffer(
        uint256 offerId
    ) external view returns (uint256) {
        Offer memory offer = offers[offerId];
        return (offer.tokenInfo.amount * (10000 + marketplaceFee)) / 10000;
    }
}
