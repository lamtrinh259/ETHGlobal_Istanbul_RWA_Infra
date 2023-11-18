// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

// OpenZeppelin Contracts (last updated v5.0.0) (utils/Context.sol)

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC721/IERC721.sol)

// OpenZeppelin Contracts (last updated v5.0.0) (utils/introspection/IERC165.sol)

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or
     *   {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the address zero.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC721/IERC721Receiver.sol)

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be
     * reverted.
     *
     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/IERC20.sol)

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// OpenZeppelin Contracts (last updated v5.0.0) (utils/Address.sol)

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev The ETH balance of the account is not enough to perform the operation.
     */
    error AddressInsufficientBalance(address account);

    /**
     * @dev There's no code at `target` (it is not a contract).
     */
    error AddressEmptyCode(address target);

    /**
     * @dev A call to an address target failed. The target may have reverted.
     */
    error FailedInnerCall();

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.8.20/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        if (address(this).balance < amount) {
            revert AddressInsufficientBalance(address(this));
        }

        (bool success, ) = recipient.call{value: amount}("");
        if (!success) {
            revert FailedInnerCall();
        }
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason or custom error, it is bubbled
     * up by this function (like regular Solidity function calls). However, if
     * the call reverted with no returned reason, this function reverts with a
     * {FailedInnerCall} error.
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        if (address(this).balance < value) {
            revert AddressInsufficientBalance(address(this));
        }
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and reverts if the target
     * was not a contract or bubbling up the revert reason (falling back to {FailedInnerCall}) in case of an
     * unsuccessful call.
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata
    ) internal view returns (bytes memory) {
        if (!success) {
            _revert(returndata);
        } else {
            // only check if target is a contract if the call was successful and the return data is empty
            // otherwise we already know that it was a contract
            if (returndata.length == 0 && target.code.length == 0) {
                revert AddressEmptyCode(target);
            }
            return returndata;
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and reverts if it wasn't, either by bubbling the
     * revert reason or with a default {FailedInnerCall} error.
     */
    function verifyCallResult(bool success, bytes memory returndata) internal pure returns (bytes memory) {
        if (!success) {
            _revert(returndata);
        } else {
            return returndata;
        }
    }

    /**
     * @dev Reverts with returndata if present. Otherwise reverts with {FailedInnerCall}.
     */
    function _revert(bytes memory returndata) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert FailedInnerCall();
        }
    }
}

interface IProxy {
    function read() external view returns (int224 value, uint32 timestamp);

    function api3ServerV1() external view returns (address);
}

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

    address public ethUsdProxy = 0x26690F9f17FdC26D419371315bc17950a0FC90eD;
    address public usdcUsdProxy = 0x8DF7d919Fe9e866259BB4D135922c5Bd96AF6A27;

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

    function setProxyAddresses(
        address _ethUsd,
        address _usdUsdc
    ) public onlyOwner {
        ethUsdProxy = _ethUsd;
        usdcUsdProxy = _usdUsdc;
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

    function getETHtoUSD()
        external
        view
        returns (int224 value, uint256 timestamp)
    {
        return IProxy(ethUsdProxy).read();
    }

    function getUSDCtoUSD()
        external
        view
        returns (int224 value, uint256 timestamp)
    {
        return IProxy(usdcUsdProxy).read();
    }
}
