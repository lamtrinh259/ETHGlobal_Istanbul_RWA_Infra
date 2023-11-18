// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract Shop is
    ERC721,
    ERC721Enumerable,
    ERC721Pausable,
    Ownable,
    ERC721Burnable
{
    using Strings for uint256;

    uint256 private _nextTokenId;
    mapping(uint256 => string) private tokenURIs;

    constructor(
        address initialOwner
    ) ERC721("Shop", "SHP") Ownable(initialOwner) {}

    // Admin functions

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, string memory tokenUri) public onlyOwner {
        uint256 tokenId = ++_nextTokenId;
        _safeMint(to, tokenId);
        tokenURIs[tokenId] = tokenUri;
    }

    function setTokenUri(
        uint256 tokenId,
        string memory uri
    ) external onlyOwner {
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
