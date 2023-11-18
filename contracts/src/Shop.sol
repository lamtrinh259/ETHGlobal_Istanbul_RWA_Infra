// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

import {GelatoRelayContextERC2771} from "@gelatonetwork/relay-context/contracts/GelatoRelayContextERC2771.sol";

contract Shop is
    ERC721,
    ERC721Enumerable,
    ERC721Pausable,
    Ownable,
    ERC721Burnable,
    GelatoRelayContextERC2771
{
    using Strings for uint256;

    uint256 private _nextTokenId;
    mapping(uint256 => string) private tokenURIs;

    modifier onlyOwnerRelayed() {
        require(_getMsgSender() == owner(), "Only owner");
        _;
    }

    constructor(
        address initialOwner
    ) ERC721("Shop", "SHP") Ownable(initialOwner) {}

    // Admin functions

    function pause() public onlyOwnerRelayed {
        _pause();
    }

    function unpause() public onlyOwnerRelayed {
        _unpause();
    }

    function _baseMint(address to, string memory tokenUri) private {
        uint256 tokenId = ++_nextTokenId;
        _safeMint(to, tokenId);
        tokenURIs[tokenId] = tokenUri;
    }

    function mint(address to, string memory tokenUri) public onlyOwnerRelayed {
        _baseMint(to, tokenUri);
    }

    function mintRelayed(
        address to,
        string memory tokenUri
    ) public onlyOwnerRelayed {
        require(_isGelatoRelayERC2771(msg.sender), "Only Gelato Relayer");
        _transferRelayFee();
        _baseMint(to, tokenUri);
    }

    function setTokenUri(
        uint256 tokenId,
        string memory uri
    ) external onlyOwnerRelayed {
        tokenURIs[tokenId] = uri;
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address to,
        uint256 tokenId,
        address auth
    )
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(
        address account,
        uint128 value
    ) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // Other view functions

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return tokenURIs[tokenId];
    }
}
